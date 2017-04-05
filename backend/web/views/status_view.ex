defmodule Arrivals.StatusView do
  use Arrivals.Web, :view

  def render("index.json", %{ statuses: statuses }) do
    %{
      statuses: Enum.map(statuses, &status_json/1)
    }
  end

  def render("show.json", %{ status: status}) do
    status_json(status)
  end

  def status_json status do
    %{
      id: status.id,
      name: status.name,
      real_time: status.real_time,
      inserted_at: status.inserted_at
    }
  end
end
