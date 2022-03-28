defmodule Orig.Repo.Migrations.CreateApplicantProfiles do
  use Ecto.Migration

  def change do

    create table(:applicant_profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :app_id, references(:origination_apps, column: :app_id, type: :uuid)
      add :first_name, :string
      add :last_name, :string
      add :address1, :string
      add :address2, :string
      add :city, :string
      add :state, :string
      add :postcode, :string

      timestamps()
    end

    create unique_index(:applicant_profiles, [:app_id])
  end
end
