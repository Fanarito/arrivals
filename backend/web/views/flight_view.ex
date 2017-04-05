defmodule Arrivals.FlightView do
  use Arrivals.Web, :view

  def render("index.json", %{ data: data }) do
    %{
      flights: Enum.map(data, &flight_json/1)
    }
  end

  def render("show.json", %{ flight: data, statuses: statuses }) do
    %{
      id: data.flight.id,
      date: data.flight.date,
      number: data.flight.number,
      scheduled_time: data.flight.scheduled_time,
      statuses: render_many(statuses, Arrivals.StatusView, "show.json"),
      latest_status: render_one(data.latest_status, Arrivals.StatusView, "show.json"),
      airline: render_one(data.airline, Arrivals.AirlineView, "no_detail.json"),
      location: render_one(data.location, Arrivals.LocationView, "no_detail.json")
    }
  end

  def flight_json data do
    %{
      id: data.flight.id,
      date: data.flight.date,
      number: data.flight.number,
      scheduled_time: data.flight.scheduled_time,
      latest_status: render_one(data.latest_status, Arrivals.StatusView, "show.json"),
      airline: render_one(data.airline, Arrivals.AirlineView, "no_detail.json"),
      location: render_one(data.location, Arrivals.LocationView, "no_detail.json")
    }
  end
  # require Ecto.Query

  # attributes [:date, :number, :scheduled_time]

  # has_one :airline,
  #   serializer: Arrivals.AirlineView,
  #   include: false,
  #   identifiers: :when_included

  # has_one :location,
  #   serializer: Arrivals.LocationView,
  #   include: false,
  #   identifiers: :when_included

  # has_one :latest_status,
  #   serializer: Arrivals.StatusView,
  #   include: true

  # has_many :statuses,
  #   serializer: Arrivals.StatusView,
  #   include: false,
  #   identifiers: :when_included

  # def latest_status(flight) do
  #   Flight.latest_status(flight)
  #   |> Ecto.Query.select([f, s1], f)
  # end

  # def preload(flight_or_flights, _conn, _include_opts) do
  #   flight_or_flights
  #   |> Arrivals.Repo.preload(:airline)
  #   |> Arrivals.Repo.preload(:statuses)
  #   |> Arrivals.Repo.preload(:location)
  # end

  # def statuses(flight, _conn) do
  #   Status.for_flight(flight)
  # end
end
