defmodule Orig.Events.ApplicantProfile.ApplicantProfileProjector do
  use Commanded.Projections.Ecto,
    application: Orig.Events.Application,
    repo: Orig.Repo,
    name: "applicant_profile",
    consistency: :strong

  alias Orig.Events.ApplicantProfile.ApplicantProfileChanged
  alias Orig.Originations.ApplicantProfile
  alias Ecto.Multi
  alias Orig.Repo

  project(
    %ApplicantProfileChanged{applicant_profile: new_profile, persistence: "create"},
    fn multi ->
      cs = ApplicantProfile.changeset(%ApplicantProfile{}, new_profile)
      Multi.insert(multi, :applicant_profiles, cs)
    end
  )

  project(
    %ApplicantProfileChanged{
      applicant_profile: changed_profile,
      persistence: "update",
      app_id: app_id
    },
    fn multi ->
      cs =
        ApplicantProfile
        |> Repo.get_by(app_id: app_id)
        |> ApplicantProfile.changeset(changed_profile)

      Multi.update(multi, :applicant_profiles, cs)
    end
  )

  def error({:error, _error}, _event, _ctx) do
    :skip
  end
end
