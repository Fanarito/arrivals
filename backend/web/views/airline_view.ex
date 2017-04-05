defmodule Arrivals.AirlineView do
  use Arrivals.Web, :view

  def render("no_detail.json", %{ airline: airline }) do
    %{
      id: airline.id,
      name: airline.name
    }
  end
end
