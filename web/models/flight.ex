defmodule Arrivals.Flight do
  use Arrivals.Web, :model

  schema "flights" do
    field :date, Timex.Ecto.Date
    field :number, :string
    field :scheduled_time, Timex.Ecto.DateTime
    field :real_time, Timex.Ecto.DateTime

    belongs_to :location, Arrivals.Location
    belongs_to :airline, Arrivals.Airline
    belongs_to :status, Arrivals.Status
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
