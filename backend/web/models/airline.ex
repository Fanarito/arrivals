defmodule Arrivals.Airline do
  use Arrivals.Web, :model

  schema "airlines" do
    field :name, :string

    has_many :flights, Arrivals.Flight
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
