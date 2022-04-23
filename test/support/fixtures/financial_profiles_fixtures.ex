defmodule Orig.FinancialProfilesFixtures do
  import Orig.OriginationsFixtures

  def financial_profile_fixture(attrs \\ %{}) do
    origination_app = origination_app_fixture()

    {:ok, financial_profile} =
      attrs
      |> Enum.into(%{
        app_id: origination_app.app_id,
        periodic_income: 1000,
        pay_period: :biweekly,
        primary_routing_number: "1112223334",
        primary_account_number: "8887776655432"
      })
      |> Orig.Originations.create_financial_profile()

    financial_profile
  end
end
