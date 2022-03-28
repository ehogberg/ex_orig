defmodule Orig.Events.OrigApplicationRouter do
  use Commanded.Commands.Router

  alias Orig.Events.CommandHandlers
  alias Orig.Events.OriginationApp.{CreateOriginationApp, RejectOriginationApp}
  alias Orig.Events.ApplicantProfile.{ChangeApplicantProfile}
  alias Orig.Originations.{OriginationApp, ApplicantProfile}

  identify(OriginationApp, by: :app_id)
  identify(ApplicantProfile, by: :app_id, prefix: "applicant-profile-")

  dispatch(CreateOriginationApp, to: CommandHandlers, aggregate: OriginationApp)
  dispatch(RejectOriginationApp, to: CommandHandlers, aggregate: OriginationApp)

  dispatch(ChangeApplicantProfile, to: CommandHandlers, aggregate: ApplicantProfile)
end
