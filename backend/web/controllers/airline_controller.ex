defmodule Arrivals.AirlineController do
  use Arrivals.Web, :controller
  alias Arrivals.Airline

  def index(conn, _params) do
    airlines = Arrivals.Repo.all(Airline)

    # conn |> json(data: airlines)
    # render conn, "index.json", data: airlines
    conn |> render("index.json-api", data: airlines)
  end
end
