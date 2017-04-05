defmodule Scraper do
  use GenServer
  use Timex
  require Logger
  import Ecto.Query

  alias Arrivals.Flight
  alias Arrivals.Airline
  alias Arrivals.Location
  alias Arrivals.Status

  @urls ["https://www.kefairport.is/English/Timetables/Arrivals/Yesterday",
         "https://www.kefairport.is/English/Timetables/Arrivals/",
         "https://www.kefairport.is/English/Timetables/Arrivals/Tomorrow/"]

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    handle_info(:work, state)
    {:ok, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 5 * 60 * 1000) # every 5 minutes
  end

  def handle_info(:work, state) do
    Logger.info "scraping now"

    Enum.each(@urls, &handle_url/1)

    Logger.info "done scraping"

    schedule_work()
    {:noreply, state}
  end

  def handle_url(url) do
    with {:ok, body} <- get_site_body(url),
         {:ok, rows} <- get_rows(body) do
      [yesterday, today] = handle_rows(rows)
      Enum.concat(
        Enum.map(yesterday, &shift_flight_back_by_day/1),
        today)
      |> Enum.each(&handle_row/1)
    else
      {:error, error} -> Logger.error "Something went wrong: #{error}"
    end
  end

  def get_site_body(url) do
    HTTPoison.start
    case HTTPoison.get(url) do
      {:ok, res} -> {:ok, res.body}
      {:error, res} -> {:error, "Website could not be reached"}
    end
  end

  def get_rows(body) do
    {:ok, Floki.find(body, "tr") |> Enum.drop(1)}
  end

  def handle_row(flight) do
    flights_today = Arrivals.Repo.one(
      from f in Arrivals.Flight,
      where: f.number == ^flight.number and f.date == ^flight.date,
      select: f
    )

    case flights_today do
      nil ->
        add_flight(flight)
      _ ->
        update_flight(flights_today.id, flight);
    end
  end

  def add_flight(row) do
    flight = %Flight{
      number: row.number,
      airline_id: row.airline_id,
      location_id: row.location_id,
      scheduled_time: row.scheduled_time,
      date: row.date
    }
    inserted_flight = Arrivals.Repo.insert!(flight)
    add_status(row.status, inserted_flight.id)
  end

  def update_flight(flight_id, row) do
    flight = Arrivals.Repo.get!(Flight, flight_id)
    add_status(row.status, flight.id)
  end

  def add_status(status, flight_id) do
    latest_status = Status
    |> where(flight_id: ^flight_id)
    |> last
    |> Arrivals.Repo.one

    status = Ecto.Changeset.change(status, flight_id: flight_id)

    case latest_status do
      nil ->
        Arrivals.Repo.insert!(status)
      _ ->
        real_time_query = if status.data.real_time == nil do
            dynamic([s], is_nil(s.real_time))
          else
            dynamic([s], s.real_time == ^status.data.real_time)
          end
        latest_status = Status
        |> where(flight_id: ^flight_id)
        |> where(name: ^status.data.name)
        |> where(^real_time_query)
        |> last
        |> Arrivals.Repo.one
        case latest_status do
          nil ->
            Arrivals.Repo.insert!(status)
          _ ->
            Logger.debug "status already in"
        end
    end
  end

  def handle_rows(rows) do
    parsed_rows = Enum.map(rows, &parse_row/1)

    # Gets the rows that have a dulpicate flight number after them
    yesterday = Enum.filter_map(Enum.with_index(parsed_rows), fn {row, idx} ->
      Enum.any?(
        Enum.drop(parsed_rows, idx + 1),
        fn row_inner ->
          row.number == row_inner.number
        end
      )
    end,
      &(elem(&1, 0))
    )

    # Gets all rows except the ones from yesterday
    today = Enum.reverse(parsed_rows)
    |> Enum.uniq_by(fn row -> row.number end)
    |> Enum.reverse

    [yesterday, today]
  end

  def parse_row(row) do
    [date_string, number, airline_string, location_string, sc_time_string, status_string | _] =
      Floki.find(row, "td") |> Enum.concat(["None"]) |> Floki.text(sep: "|") |> String.split("|")

    date = parse_date(date_string)
    scheduled_time = parse_time(sc_time_string, date)
    airline_id = insert_airline(airline_string)
    location_id = insert_location(location_string)
    [parsed_status, re_time] = parse_status(status_string, date)
    status = prepare_status(parsed_status, re_time)

    %{
      date: date,
      number: number,
      airline_id: airline_id,
      location_id: location_id,
      scheduled_time: scheduled_time,
      status: status
    }
  end

  def shift_flight_back_by_day(flight) do
    date = Timex.shift(flight.date, days: -1)
    scheduled_time = Timex.shift(flight.scheduled_time, days: -1)
    %{
      date: date,
      number: flight.number,
      airline_id: flight.airline_id,
      location_id: flight.location_id,
      status: flight.status,
      scheduled_time: scheduled_time
    }
  end

  # Inserts status if ther is no status with the same name
  def prepare_status(status_name, real_time) do
    Ecto.Changeset.change(
      %Status{
        name: status_name,
        real_time: real_time
      }
    )
  end

  def insert_airline(airline_name) do
    airline_in_db = Arrivals.Repo.one(
      from a in Airline,
      where: a.name == ^airline_name,
      select: a
    )

    # If the airline is already in db, then just use that record,
    # else insert it
    case airline_in_db do
      nil ->
        inserted = Arrivals.Repo.insert!(%Airline{name: airline_name})
        inserted.id
      _ ->
        airline_in_db.id
    end
  end

  # inserts location if there is no location with the same name
  def insert_location(location_name) do
    location_in_db = Arrivals.Repo.one(
      from l in Location,
      where: l.name == ^location_name,
      select: l
    )

    # if the location is already in db, then just use that record,
    # else insert it
    case location_in_db do
      nil ->
        inserted = Arrivals.Repo.insert!(%Location{name: location_name})
        inserted.id
      _ ->
        location_in_db.id
    end
  end

  def parse_date(date) do
    Timex.parse!(
      Enum.join([date, DateTime.utc_now.year], " "),
      "%e. %b %Y",
      :strftime
    )
  end

  def parse_time(scheduled_time, date) do
    Logger.debug scheduled_time
    year = date.year
    month = date.month |> Integer.to_string |> String.rjust(2, ?0)
    day = date.day
    case Timex.parse(
      Enum.join([scheduled_time, year, month, day], " "),
      "%H:%M %Y %m %e",
      :strftime
        ) do
      {:ok, time} -> time
      {:error, _readson} -> nil
    end
  end

  # Gets correct status, and predicted time from status
  # Statuses can come in three forms.
  # {status} {time}
  # {status}
  # {empty}
  # To get around any errors we return a struct
  # that has status, and a time, time can be null
  def parse_status(status, date) do
    status_time = String.split(status, " ")

    case Enum.count(status_time) do
      0 ->
        # No status
        ["None", time: nil]
      1 ->
        # Status but no time
        [hd(status_time) |> expand_status, nil]
      2 ->
        # Both status and time
        [hd(status_time) |> expand_status, tl(status_time) |> parse_time(date)]
    end
  end

  def expand_status(data) do
    Logger.debug data
    case data do
      "Confirm." -> "Confirmed"
      "Landed" -> "Landed"
      "Estimat." -> "Estimated"
      "Cancell." -> "Cancelled"
      _ -> data
    end
  end
end
