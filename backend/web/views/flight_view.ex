defmodule Arrivals.FlightView do
  use Arrivals.Web, :view

  attributes [:date, :number, :scheduled_time, :real_time]

  has_one :airline,
    serializer: Arrivals.AirlineView,
    include: true

  has_one :location,
    serializer: Arrivals.LocationView,
    include: true

  has_one :status,
    serializer: Arrivals.StatusView,
    include: true
end
