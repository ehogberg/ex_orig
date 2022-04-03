defmodule Orig.Repo.Migrations.CreateFinancialProfile do
  use Ecto.Migration
  alias Orig.Originations.FinancialProfile.PayPeriod

  def change do
    PayPeriod.create_type()

    create table(:financial_profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :app_id, references(:origination_apps, column: :app_id, type: :uuid)
      add :periodic_income, :float
      add :pay_period, PayPeriod.type(), default: "biweekly"
      add :primary_routing_number, :string
      add :primary_account_number, :string

      timestamps(type: :naive_datetime_usec)
    end

    create unique_index(:financial_profiles, [:app_id])
  end
end
