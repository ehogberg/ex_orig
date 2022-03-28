defmodule Orig.Repo.Migrations.CreateOriginationApps do
  use Ecto.Migration

  def change do
    create table(:origination_apps, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :app_id, :uuid
      add :ssn, :string

      timestamps(type: :naive_datetime_usec)
    end

    create unique_index(:origination_apps, [:app_id])
  end
end
