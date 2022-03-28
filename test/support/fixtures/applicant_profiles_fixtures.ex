defmodule Orig.ApplicantProfilesFixtures do

  import Orig.OriginationsFixtures

  def applicant_profile_fixture(attrs \\ %{}) do
    origination_app = origination_app_fixture()

    {:ok, applicant_profile} =
      attrs
      |> Enum.into(%{
        app_id: origination_app.app_id,
        last_name: "Applicant",
        first_name: "Aaron",
        address1: "555 Main Street",
        city: "Erehwon",
        state: "IL",
        postcode: "12345"
      })
      |> Orig.Originations.create_applicant_profile()

    applicant_profile
  end

end
