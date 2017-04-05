defmodule Arrivals.FlightController do
  use Arrivals.Web, :controller
  use Timex
  # use JaResource
  # plug JaResource, except: [:delete, :create, :update]
  alias Arrivals.Flight
  alias Arrivals.Airline
  alias Arrivals.Location
  alias Arrivals.Status
  require Logger

  def repo, do: Arrivals.Repo

  def index(conn, %{ "useful" => "true" }) do
    now = Timex.now |> Timex.shift(minutes: -90)

    query = from f in Flight,
      join: s1 in assoc(f, :statuses),
      left_join: s2 in Status, on: f.id == s2.flight_id and s1.id < s2.id,
      join: a in Airline, on: a.id == f.airline_id,
      join: l in Location, on: l.id == f.location_id,
      where: is_nil(s2.id),
      where: f.scheduled_time > ^now or s1.real_time > ^now,
      order_by: [desc: fragment("-?", s1.real_time), asc: f.scheduled_time],
      select: %{ flight: f, latest_status: s1, airline: a, location: l}
    data = Repo.all(query)
    render conn, "index.json", data: data
  end

  def index(conn, _params) do
    query = from f in Flight,
      join: s1 in assoc(f, :statuses),
      left_join: s2 in Status, on: f.id == s2.flight_id and s1.id < s2.id,
      join: a in Airline, on: a.id == f.airline_id,
      join: l in Location, on: l.id == f.location_id,
      where: is_nil(s2.id),
      order_by: [asc: f.scheduled_time, asc: s1.real_time],
      select: %{ flight: f, latest_status: s1, airline: a, location: l}
    data = Repo.all(query)
    render conn, "index.json", data: data
  end

  def show(conn, params) do
    query = from f in Flight,
      join: s1 in assoc(f, :statuses),
      left_join: s2 in Status, on: f.id == s2.flight_id and s1.id < s2.id,
      join: a in Airline, on: a.id == f.airline_id,
      join: l in Location, on: l.id == f.location_id,
      where: is_nil(s2.id),
      where: f.id == ^params["id"],
      select: %{ flight: f, latest_status: s1, airline: a, location: l}
    flight = Repo.one(query)
    statuses = Repo.all(Status.for_flight(flight.flight) |> order_by(desc: :inserted_at))
    render conn, "show.json", flight: flight, statuses: statuses
  end
end
