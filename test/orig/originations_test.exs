defmodule Orig.OriginationsTest do
  use Orig.DataCase
  use Orig.InMemoryEventStoreCase

  alias Orig.Originations

  describe "origination_apps" do
    alias Orig.Originations.OriginationApp

    import Orig.OriginationsFixtures

    @invalid_attrs %{app_id: nil, ssn: nil}

    test "list_origination_apps/0 returns all origination_apps" do
      origination_app = origination_app_fixture()
      assert Originations.list_origination_apps() == [origination_app]
    end

    test "get_origination_app_by_applicant_id/1 returns a origination app" do
      origination_app = origination_app_fixture()

      assert Originations.get_origination_app_by_applicant_id(origination_app.ssn) ==
               origination_app
    end

    test "get_origination_app_by_applicant_id/1 returns nil if no match" do
      assert Originations.get_origination_app_by_applicant_id("0") == nil
    end

    test "create_origination_app/1 with valid data creates a new origination_app" do
      valid_attrs = %{app_id: "7488a646-e31f-11e4-aace-600308960662", ssn: "111223333"}

      assert {:ok, %OriginationApp{} = origination_app} =
               Originations.create_origination_app(valid_attrs)

      assert origination_app.app_id == "7488a646-e31f-11e4-aace-600308960662"
      assert origination_app.ssn == "111223333"
      assert origination_app.app_status == :new
    end

    test "create_origination_app/1 returns error when trying to re-create an existing app" do
      origination_app = origination_app_fixture()

      assert {:error, :orig_app_already_exists} =
               Originations.create_origination_app(%{
                 app_id: origination_app.app_id,
                 ssn: "333445555"
               })
    end

    test "create_origination_app/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Originations.create_origination_app(@invalid_attrs)
    end

    test "find_or_create_origination_app/1 returns an active application, if one exists" do
      origination_app = origination_app_fixture()

      assert origination_app == Originations.find_or_create_origination_app("111223333")
    end

    test "find_or_create_origination_app/1 creates a new application if
          there is no existing one matching applicant id" do
      origination_app_fixture()
      assert %OriginationApp{} = Originations.find_or_create_origination_app("222334444")
      assert Enum.count(Originations.list_origination_apps()) == 2
    end

    test "reject_origination_app/1 rejects an active origination app" do
      origination_app = origination_app_fixture()
      Originations.reject_origination_app(origination_app.app_id)

      rejected_origination_app =
        Originations.find_origination_app_by_app_id(origination_app.app_id)

      assert rejected_origination_app.app_status == :rejected
    end

    test "reject_origination_app/1 errs if no such app exists" do
      assert {:error, :no_origination_app_found_to_reject} ==
               Originations.reject_origination_app("99999")
    end

    test "reject_origination_app/1 errs if app already rejected" do
      origination_app = origination_app_fixture()
      Originations.reject_origination_app(origination_app.app_id)

      assert {:error, :orig_app_already_rejected} ==
               Originations.reject_origination_app(origination_app.app_id)
    end

    test "change_origination_app/1 returns a origination_app changeset" do
      origination_app = origination_app_fixture()
      assert %Ecto.Changeset{} = Originations.change_origination_app(origination_app)
    end
  end
end
