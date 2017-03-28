defmodule Scraper do
  use GenServer
  use Timex
  require Logger
  import Ecto.Query

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send(self(), :work)
    schedule_work()
    {:ok, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 5 * 60 * 1000) # every 5 minutes
  end

  def handle_info(:work, state) do
    Logger.info "scraping now"

    get_site_body!("https://www.kefairport.is/English/Timetables/Arrivals/")
    |> get_rows
    |> Enum.map(fn row -> parse_row(row) |> insert_flight end)

    Logger.info "done scraping"

    # Start the process again in x minutes
    schedule_work()
    {:noreply, state}
  end

  def get_site_body(url) do
    HTTPoison.start
    body = HTTPoison.get!(url).body
    {:ok, body}
  end

  def get_site_body!(url) do
    HTTPoison.start
    body = HTTPoison.get!(url).body
    body
  end

  # Gets all relevant rows from the table that contains the flights
  def get_rows(body) do
    Floki.find(body, "tr") |> Enum.drop(1)
  end

  # Parses row
  def parse_row(row) do
    # Find all columns in row, and then append a value, because some rows have one to few columns
    [date, number, airline, location, sc_time, status | _] =
      Floki.find(row, "td") |> Enum.concat(["None"]) |> Floki.text(sep: "|") |> String.split("|")

    parsed_date = parse_date(date)
    parsed_sc_time = parse_time(sc_time, parsed_date)
    [parsed_status, re_time] = parse_status(status, parsed_date)
    status_id = insert_status(parsed_status)
    airline_id = insert_airline(airline)
    location_id = insert_location(location)

    [parsed_date, number, airline_id, location_id, parsed_sc_time, re_time, status_id]
  end

  def insert_flight(flight_details) do
    [date, number, airline_id, location_id, sc_time, re_time, status_id] = flight_details

    yesterday = Timex.shift(date, days: -1)

    # Check if there where any flights yesterday with the same flight number
    # if there were any, check if the status is either landed or cancelled
    flights_yesterday = Arrivals.Repo.one(
      from f in Arrivals.Flight,
      join: s in assoc(f, :status),
      where: f.number == ^number and f.date == ^yesterday and s.type != "Cancelled" and s.type != "Landed",
      select: f
    )

    case flights_yesterday do
      nil ->
        check_flights_today(flight_details)
      _ ->
        update_flight(flights_yesterday.id, flight_details)
    end
  end

  def check_flights_today(flight_details) do
    [date, number, airline_id, location_id, sc_time, re_time, status_id] = flight_details

    flights_today = Arrivals.Repo.one(
      from f in Arrivals.Flight,
      where: f.number == ^number and f.date == ^date,
      select: f
    )

    case flights_today do
      nil ->
        add_flight(flight_details)
      _ ->
        update_flight(flights_today.id, flight_details);
    end
  end

  def add_flight(flight_details) do
    [date, number, airline_id, location_id, sc_time, re_time, status_id] = flight_details

    flight = %Arrivals.Flight{
      number: number,
      airline_id: airline_id,
      location_id: location_id,
      status_id: status_id,
      scheduled_time: sc_time,
      real_time: re_time,
      date: date
    }
    Arrivals.Repo.insert!(flight)
  end

  def update_flight(flight_id, flight_details) do
    [date, number, airline_id, location_id, sc_time, re_time, status_id] = flight_details

    flight = Arrivals.Repo.get!(Arrivals.Flight, flight_id)
    flight = Ecto.Changeset.change(flight, %{real_time: re_time, status_id: status_id})
    Arrivals.Repo.update(flight)
  end

  # Inserts status if ther is no status with the same type
  def insert_status(status_type) do
    status = Arrivals.Repo.one(
      from s in Arrivals.Status,
      where: s.type == ^status_type,
      select: s
    )
    case status do
      nil ->
        inserted = Arrivals.Repo.insert!(%Arrivals.Status{type: status_type})
        inserted.id
      _ ->
        status.id
    end
  end

  # Inserts airline if there is no airline with the same name
  def insert_airline(airline_name) do
    airline_in_db = Arrivals.Repo.one(
      from a in Arrivals.Airline,
      where: a.name == ^airline_name,
      select: a
    )

    # If the airline is already in db, then just use that record,
    # else insert it
    case airline_in_db do
      nil ->
        inserted = Arrivals.Repo.insert!(%Arrivals.Airline{name: airline_name})
        inserted.id
      _ ->
        airline_in_db.id
    end
  end

  # Inserts location if there is no location with the same name
  def insert_location(location_name) do
    location_in_db = Arrivals.Repo.one(
      from l in Arrivals.Location,
      where: l.name == ^location_name,
      select: l
    )

    # If the location is already in db, then just use that record,
    # else insert it
    case location_in_db do
      nil ->
        inserted = Arrivals.Repo.insert!(%Arrivals.Location{name: location_name})
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
    year = date.year
    month = date.month |> Integer.to_string |> String.rjust(2, ?0)
    day = date.day
    Timex.parse!(
      Enum.join([scheduled_time, year, month, day], " "),
      "%H:%M %Y %m %e",
      :strftime
    )
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
    case data do
      "Confirm." -> "Confirmed"
      "Landed" -> "Landed"
      "Estimat." -> "Estimated"
      "Cancell." -> "Cancelled"
      _ -> data
    end
  end
end
