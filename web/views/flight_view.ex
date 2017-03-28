defmodule Arrivals.FlightView do
  use Arrivals.Web, :view
  use Timex

  def render("index.json", %{flights: flights}) do
    %{
      data: flights
    }
  end

end
