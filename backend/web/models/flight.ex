defmodule Arrivals.Flight do
  use Arrivals.Web, :model
  use Timex
  import Ecto.Query
  alias Arrivals.Airline
  alias Arrivals.Location
  alias Arrivals.Status
  alias Arrivals.Flight
  alias Arrivals.Repo

  schema "flights" do
    field :date, Timex.Ecto.Date
    field :number, :string
    field :scheduled_time, Timex.Ecto.DateTime
    belongs_to :location, Arrivals.Location
    belongs_to :airline, Arrivals.Airline
    has_many :statuses, Arrivals.Status

    timestamps()
  end

  def closest_flights(query) do
    now = Timex.now |> Timex.shift(minutes: -90)
    from f in query,
      join: s in assoc(f, :status),
      where: (f.scheduled_time > ^now or f.real_time > ^now),
      order_by: [desc: fragment("-?", f.real_time), asc: f.scheduled_time]
  end

  def latest_status(query) do
    from f in query,
      join: s1 in assoc(f, :statuses),
      left_join: s2 in Status, on: f.id == s2.flight_id and s1.id < s2.id,
      where: is_nil(s2.id)
  end

  def show_flight_query(flight_id) do
    query = from f in Flight,
      join: s1 in assoc(f, :statuses),
      left_join: s2 in Status, on: f.id == s2.flight_id and s1.id < s2.id,
      join: a in Airline, on: a.id == f.airline_id,
      join: l in Location, on: l.id == f.location_id,
      where: is_nil(s2.id),
      where: f.id == ^flight_id,
      select: %{ flight: f, latest_status: s1, airline: a, location: l}
    flight = Repo.one(query)
    statuses = Repo.all(Status.for_flight(flight.flight) |> order_by(desc: :inserted_at))

    %{
      flight: flight,
      statuses: statuses
    }
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:date, :number, :scheduled_time])
    |> validate_required([:date, :number, :scheduled_time])
  end
end
