defmodule Arrivals.Status do
  use Arrivals.Web, :model
  use Timex
  import Ecto.Query
  alias Arrivals.Airline
  alias Arrivals.Location
  alias Arrivals.Status

  schema "statuses" do
    field :name, :string
    field :real_time, Timex.Ecto.DateTime
    belongs_to :flight, Arrivals.Flight

    timestamps()
  end

  def for_flight(flight) do
    Status
    |> where([s], s.flight_id == ^flight.id)
    |> select([s], s)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :real_time])
    |> validate_required([:name, :real_time])
  end
end
