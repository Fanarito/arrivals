defmodule Arrivals.Airline do
  use Arrivals.Web, :model
  import Ecto.Query

  schema "airlines" do
    field :name, :string

    timestamps()

    has_many :flights, Arrivals.Flight
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
