defmodule Arrivals.Repo.Migrations.CreateAll do
  use Ecto.Migration

  def change do
    create table(:airline) do
      add :name, :string
    end
  end
end
