defmodule Arrivals.LocationView do
  use Arrivals.Web, :view

  def render("no_detail.json", %{ location: location }) do
    %{
      id: location.id,
      name: location.name
    }
  end
end
