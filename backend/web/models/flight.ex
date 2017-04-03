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

    timestamps

    belongs_to :location, Location
    belongs_to :airline, Airline
    belongs_to :status, Status
  end

  def closest_flights(query) do
    now = Timex.now |> Timex.shift(minutes: -90)
    from f in query,
      join: s in assoc(f, :status),
      where: (f.scheduled_time > ^now or f.real_time > ^now) and (not is_nil(f.real_time) or s.name == "Cancelled"),
      order_by: [asc: f.real_time]
  end

  def flights_landed_recently(query) do
    today = Timex.now
    yesterday = today |> Timex.shift(days: -1)
    from f in query,
      join: s in assoc(f, :status),
      where: s.name == "Landed" or s.name == "None",
      where: f.scheduled_time > ^yesterday or f.real_time > ^yesterday,
      order_by: [asc: f.real_time, asc: f.scheduled_time]
  end

  def standard_view(query) do
    from f in query,
      join: s in assoc(f, :status),
      join: l in assoc(f, :location),
      join: a in assoc(f, :airline),
      select: %{
        id: f.id,
        date: f.date,
        number: f.number,
        airline: a,
        location: l,
        scheduled_time: f.scheduled_time,
        real_time: f.real_time,
        status: s
      }
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :number, :scheduled_time])
    |> validate_required([:name, :number, :scheduled_time])
  end
end
