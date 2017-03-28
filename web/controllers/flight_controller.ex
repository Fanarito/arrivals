defmodule Arrivals.FlightController do
  use Arrivals.Web, :controller
  alias Arrivals.Flight
  alias Arrivals.Airline
  alias Arrivals.Location
  alias Arrivals.Status
  require Logger

  def index(conn, _params) do
    flights = Flight.standard_view(from f in Flight) |> Flight.sorted |> Arrivals.Repo.all

    conn
    |> put_flash(:info, "Some info")
    |> put_flash(:error, "Some erros")
    |> render("index.html", flights: flights)
  end
end
