defmodule Arrivals.Status do
  use Arrivals.Web, :model

  schema "status" do
    field :type, :string

    has_many :flights, Arrivals.Flight
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type])
    |> validate_required([:type])
  end
end
