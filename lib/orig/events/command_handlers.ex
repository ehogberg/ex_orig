defmodule Orig.Events.CommandHandlers do
  @behaviour Commanded.Commands.Handler

  alias Orig.Events.OriginationApp.{CreateOriginationApp,OriginationAppCreated,
    RejectOriginationApp, OriginationAppRejected}
  alias Orig.Events.ApplicantProfile.{ChangeApplicantProfile, ApplicantProfileChanged}

  alias Orig.Originations.{OriginationApp, ApplicantProfile}

  #### Create origination app...

  #Create only if there's no application already existing w/ the same app id.
  @impl true
  def handle(%OriginationApp{app_id: nil} = _agg, %CreateOriginationApp{} = create) do
    struct(OriginationAppCreated, Map.from_struct(create))
  end

  # If a match found on the id, reject the create request.
  @impl true
  def handle(%OriginationApp{}, %CreateOriginationApp{}), do: {:error, :orig_app_already_exists}

  #### Reject origination app...

  # Err out rejection if no existing app found to reject.
  @impl true
  def handle(%OriginationApp{app_id: nil}, %RejectOriginationApp{}),
    do: {:error, :no_origination_app_found_to_reject}

  # Err out rejection if app is already rejected.
  @impl true
  def handle(%OriginationApp{app_status: "rejected"}, %RejectOriginationApp{}),
    do: {:error, :orig_app_already_rejected}

  # Base case
  @impl true
  def handle(%OriginationApp{} = _app, %RejectOriginationApp{} = reject) do
    struct(OriginationAppRejected, Map.from_struct(reject))
  end

  #### Applicant Profile

  # create app profile if one doesn't exist for the app id.
  @impl true
  def handle(%ApplicantProfile{app_id: nil}, %ChangeApplicantProfile{persistence: "create"} = chg) do
    %ApplicantProfileChanged{applicant_profile: chg.applicant_profile,
      app_id: chg.app_id, persistence: chg.persistence}
  end

  # create app profile:  base case; reject if a profile already exists
  @impl true
  def handle(%ApplicantProfile{}, %ChangeApplicantProfile{persistence: "create"}),
    do: {:error, :applicant_profile_exists}

  #update app prof:  reject if no app prof exists
  @impl true
  def handle(%ApplicantProfile{app_id: nil}, %ChangeApplicantProfile{persistence: "update"}),
    do: {:error, :applicant_profile_not_found}

  #update app prof:  update if exists
  @impl true
  def handle(%ApplicantProfile{}, %ChangeApplicantProfile{persistence: "update"} = chg) do
    %ApplicantProfileChanged{applicant_profile: chg.applicant_profile,
      app_id: chg.app_id, persistence: chg.persistence}
  end
end
