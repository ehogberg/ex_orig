defmodule Orig.OriginationsTest do
  use Orig.DataCase

  alias Orig.Originations

  describe "origination_apps" do
    alias Orig.Originations.OriginationApp

    import Orig.OriginationsFixtures

    @invalid_attrs %{app_id: nil, ssn: nil}

    test "list_origination_apps/0 returns all origination_apps" do
      origination_app = origination_app_fixture()
      assert Originations.list_origination_apps() == [origination_app]
    end

    test "get_origination_app!/1 returns the origination_app with given id" do
      origination_app = origination_app_fixture()
      assert Originations.get_origination_app!(origination_app.id) == origination_app
    end

    test "create_origination_app/1 with valid data creates a origination_app" do
      valid_attrs = %{app_id: "7488a646-e31f-11e4-aace-600308960662", ssn: "some ssn"}

      assert {:ok, %OriginationApp{} = origination_app} = Originations.create_origination_app(valid_attrs)
      assert origination_app.app_id == "7488a646-e31f-11e4-aace-600308960662"
      assert origination_app.ssn == "some ssn"
    end

    test "create_origination_app/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Originations.create_origination_app(@invalid_attrs)
    end

    test "update_origination_app/2 with valid data updates the origination_app" do
      origination_app = origination_app_fixture()
      update_attrs = %{app_id: "7488a646-e31f-11e4-aace-600308960668", ssn: "some updated ssn"}

      assert {:ok, %OriginationApp{} = origination_app} = Originations.update_origination_app(origination_app, update_attrs)
      assert origination_app.app_id == "7488a646-e31f-11e4-aace-600308960668"
      assert origination_app.ssn == "some updated ssn"
    end

    test "update_origination_app/2 with invalid data returns error changeset" do
      origination_app = origination_app_fixture()
      assert {:error, %Ecto.Changeset{}} = Originations.update_origination_app(origination_app, @invalid_attrs)
      assert origination_app == Originations.get_origination_app!(origination_app.id)
    end

    test "delete_origination_app/1 deletes the origination_app" do
      origination_app = origination_app_fixture()
      assert {:ok, %OriginationApp{}} = Originations.delete_origination_app(origination_app)
      assert_raise Ecto.NoResultsError, fn -> Originations.get_origination_app!(origination_app.id) end
    end

    test "change_origination_app/1 returns a origination_app changeset" do
      origination_app = origination_app_fixture()
      assert %Ecto.Changeset{} = Originations.change_origination_app(origination_app)
    end
  end
end
