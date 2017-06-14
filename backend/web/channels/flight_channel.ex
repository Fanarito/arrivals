defmodule Arrivals.FlightChannel do
  use Arrivals.Web, :channel
  alias Arrivals.Flight

  def join("flight:lobby", payload, socket) do
    {:ok, socket}
  end

  def join("flight:" <> flight_id, payload, socket) do
    {:ok, "Joined channel flight:#{flight_id}", socket}
  end

  def broadcast_change(flight_id) do
    flight_statuses = Flight.show_flight_query(flight_id)
    flight = Arrivals.FlightView.render("show.json", flight_statuses)
    Arrivals.Endpoint.broadcast("flight:lobby", "insert", flight)
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end
end
