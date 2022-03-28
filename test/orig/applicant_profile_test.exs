defmodule Orig.ApplicantProfileTest do
  use Orig.DataCase
  use Orig.InMemoryEventStoreCase

  alias Orig.Originations

  describe "applicant profiles" do
    alias Orig.Originations.ApplicantProfile

    import Orig.ApplicantProfilesFixtures
    import Orig.OriginationsFixtures

    @valid_attrs %{
      app_id: "7488a646-e31f-11e4-aace-600308960662",
      first_name: "Betty",
      last_name: "Borrower",
      address1: "99 Bank St.",
      address2: "Apt. B",
      city: "Brainerd",
      state: "MN",
      postcode: "22334"
    }

    @invalid_attrs %{
      app_id: nil,
      first_name: nil,
      last_name: nil,
      address1: nil,
      city: nil,
      state: nil,
      postcode: nil
    }

    test "list_applicant_profiles/0 returns all applicant profiles" do
      applicant_profile = applicant_profile_fixture()

      assert Originations.list_applicant_profiles() == [applicant_profile]
    end

    test "find_applicant_profile_by_app_id/1 retrieves an applicant profile" do
      applicant_profile = applicant_profile_fixture()

      assert Originations.find_applicant_profile_by_app_id(applicant_profile.app_id) ==
               applicant_profile
    end

    test "find_applicant_profile_by_app_id/1 returns nil when no profile exists" do
      assert Originations.find_applicant_profile_by_app_id(Ecto.UUID.generate()) == nil
    end

    test "create_applicant_profile/1 creates a valid profile" do
      origination_app = origination_app_fixture()

      assert {:ok, %ApplicantProfile{} = app_prof} =
               Originations.create_applicant_profile(@valid_attrs)

      assert app_prof.app_id == origination_app.app_id
      assert app_prof.first_name == "Betty"
      assert app_prof.last_name == "Borrower"
      assert app_prof.address1 == "99 Bank St."
      assert app_prof.address2 == "Apt. B"
      assert app_prof.city == "Brainerd"
      assert app_prof.state == "MN"
      assert app_prof.postcode == "22334"
    end

    test "create_applicant_profile/1 errs when given invalid attrs" do
      assert {:error, %Ecto.Changeset{}} = Originations.create_applicant_profile(@invalid_attrs)
    end

    test "create_applicant_profile/1 errs when trying to create an existing profile" do
      _applicant_profile = applicant_profile_fixture()

      assert {:error, :applicant_profile_exists} ==
               Originations.create_applicant_profile(@valid_attrs)
    end

    test "update_applicant_profile/1 updates an existing applicant profile" do
      applicant_profile = applicant_profile_fixture()

      assert {:ok, upd_app_prof} =
               Originations.update_applicant_profile(applicant_profile, @valid_attrs)

      assert upd_app_prof.first_name == "Betty"
    end

    test "update_applicant_profile/1 errs when updating a non-existent app prof" do
      assert {:error, :applicant_profile_not_found} =
               Originations.update_applicant_profile(%ApplicantProfile{}, @valid_attrs)
    end

    test "change_application_profile/1 returns an app prof changeset" do
      applicant_profile = applicant_profile_fixture()
      assert %Ecto.Changeset{} = Originations.change_applicant_profile(applicant_profile)
    end
  end
end
