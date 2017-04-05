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

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:date, :number, :scheduled_time])
    |> validate_required([:date, :number, :scheduled_time])
  end
end
