defmodule Orig.Originations.FinancialProfileTest do
  use Orig.DataCase
  use Orig.InMemoryEventStoreCase

  alias Orig.Originations

  describe "financial profile" do
    alias Orig.Originations.FinancialProfile
    import Orig.OriginationsFixtures
    import Orig.FinancialProfilesFixtures

    @valid_attrs %{
      app_id: "7488a646-e31f-11e4-aace-600308960662",
      periodic_income: 2250,
      pay_period: :monthly,
      primary_routing_number: "123456789",
      primary_account_number: "1112223344567"
    }

    @invalid_attrs %{
      app_id: nil,
      periodic_income: nil,
      pay_period: nil,
      primary_routing_number: nil,
      primary_account_number: nil
    }

    test "create_financial_profile/1 creates a new financial profile record" do
      origination_app_fixture()

      assert {:ok, %FinancialProfile{} = new_fin_prof} =
               Originations.create_financial_profile(@valid_attrs)

      assert new_fin_prof.app_id == "7488a646-e31f-11e4-aace-600308960662"
      assert new_fin_prof.periodic_income == 2250
      assert new_fin_prof.pay_period == :monthly
      assert new_fin_prof.primary_routing_number == "123456789"
      assert new_fin_prof.primary_account_number == "1112223344567"
    end

    test "create_financial_profile/1 errs when creating an already-existing profile" do
      _financial_profile = financial_profile_fixture()

      assert Originations.create_financial_profile(@valid_attrs) ==
               {:error, :financial_profile_exists}
    end

    test "create_financial_profile/1 errs when given invalid input" do
      assert {:error, %Ecto.Changeset{}} = Originations.create_financial_profile(@invalid_attrs)
    end

    test "update_financial_profile/1 updates an existing financial profile" do
      financial_profile = financial_profile_fixture()

      assert {:ok, upd_fin_prof} =
               Originations.update_financial_profile(
                 financial_profile,
                 %{
                   app_id: financial_profile.app_id,
                   periodic_income: 750,
                   pay_period: :biweekly,
                   primary_routing_number: "999888654",
                   primary_account_number: "4445556677890"
                 }
               )

      assert upd_fin_prof.periodic_income == 750
      assert upd_fin_prof.pay_period == :biweekly
      assert upd_fin_prof.primary_routing_number == "999888654"
      assert upd_fin_prof.primary_account_number == "4445556677890"
    end

    test "list_financial_profiles/0 returns all financial profiles" do
      financial_profile = financial_profile_fixture()
      assert Originations.list_financial_profiles() == [financial_profile]
    end

    test "find_financial_profile_by_app_id/1 finds the correct financial profile" do
      financial_profile = financial_profile_fixture()

      assert Originations.find_financial_profile_by_app_id(financial_profile.app_id) ==
               financial_profile
    end

    test "find_financial_profile_by_app_id/1 returns nil if no matching profile" do
      assert Originations.find_financial_profile_by_app_id(Ecto.UUID.generate()) == nil
    end

    test "change_financial_profile/2 accepts valid attributes" do
      assert Originations.change_financial_profile(%FinancialProfile{}, @valid_attrs).valid?
    end

    test "change_financial_profile/2 rejects income less than 1" do
      cs =
        Originations.change_financial_profile(
          %FinancialProfile{},
          %{@valid_attrs | periodic_income: 0.75}
        )

      assert %{periodic_income: ["must be greater than 1"]} = errors_on(cs)
    end

    test "change_financial_profile/2 rejects non-numeric income" do
      cs =
        Originations.change_financial_profile(
          %FinancialProfile{},
          %{@valid_attrs | periodic_income: "not a number"}
        )

      assert %{periodic_income: ["is invalid"]} = errors_on(cs)
    end

    test "change_financial_profile/2 rejects invalid pay period" do
      cs =
        Originations.change_financial_profile(
          %FinancialProfile{},
          %{@valid_attrs | pay_period: :no_such_frequency}
        )

      assert %{pay_period: ["is invalid"]} = errors_on(cs)
    end
  end
end
