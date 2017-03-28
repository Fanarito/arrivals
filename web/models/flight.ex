defmodule Arrivals.Flight do
  use Arrivals.Web, :model
  use Timex
  import Ecto.Query
  alias Arrivals.Airline
  alias Arrivals.Location
  alias Arrivals.Status

  schema "flights" do
    field :date, Timex.Ecto.Date
    field :number, :string
    field :scheduled_time, Timex.Ecto.DateTime
    field :real_time, Timex.Ecto.DateTime

    belongs_to :location, Location
    belongs_to :airline, Airline
    belongs_to :status, Status
  end

  def closest_flights_today(query) do
    now = Timex.now |> Timex.shift(minutes: -30)
    from f in query,
      join: s in assoc(f, :status),
      where: (f.scheduled_time > ^now or f.real_time > ^now) and (not is_nil(f.real_time) or s.type == "Cancelled"),
      order_by: [asc: f.real_time]
  end

  def flights_landed_recently(query) do
    today = Timex.now
    yesterday = today |> Timex.shift(days: -1)
    from f in query,
      join: s in assoc(f, :status),
      where: s.type == "Landed" or s.type == "None",
      where: f.scheduled_time > ^yesterday or f.real_time > ^yesterday,
      order_by: [asc: f.real_time, asc: f.scheduled_time]
  end

  def standard_view(query) do
    from f in query,
      join: s in assoc(f, :status),
      join: l in assoc(f, :location),
      join: a in assoc(f, :airline),
      select: %{
        date: f.date,
        number: f.number,
        airline: a.name,
        location: l.name,
        scheduled_time: f.scheduled_time,
        real_time: f.real_time,
        status: s.type
      }
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
