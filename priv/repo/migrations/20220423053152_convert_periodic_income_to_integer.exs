defmodule Orig.Repo.Migrations.ConvertPeriodicIncomeToInteger do
  use Ecto.Migration

  def change do

    alter table(:financial_profiles) do
      modify :periodic_income, :integer
    end
  end
end
