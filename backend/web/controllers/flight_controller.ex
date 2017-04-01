defmodule Arrivals.FlightController do
  use Arrivals.Web, :controller
  alias Arrivals.Flight
  alias Arrivals.Airline
  alias Arrivals.Location
  alias Arrivals.Status
  require Logger

  def index(conn, _params) do
    flights = Flight.standard_view(from f in Flight)
    |> Flight.closest_flights_today
    |> Arrivals.Repo.all

    conn
    |> render("index.json-api", data: flights)
  end
end
