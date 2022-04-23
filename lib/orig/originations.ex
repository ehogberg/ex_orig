defmodule Orig.Originations do
  require Logger

  @moduledoc """
  The Originations context.
  """

  alias Orig.Repo
  alias Orig.Originations.{OriginationApp, ApplicantProfile, FinancialProfile}
  alias Orig.Events.OriginationApp.{RejectOriginationApp}

  @doc """
  Returns the list of origination_apps.
  """
  def list_origination_apps do
    Repo.all(OriginationApp)
  end

  def get_origination_app_by_applicant_id(applicant_id),
    do: Repo.get_by(OriginationApp, ssn: applicant_id)

  @doc """
  Creates a origination_app.  An applicant identifier (ssn)
  must be supplied as part of the call.  An origination
  application ID (UUID) may be supplied as part of the
  call; if not supplied, one will be automatically
  generated.
  """
  def create_origination_app(%{ssn: _ssn} = attrs) do
    # Make sure there's an app id, but don't overwrite
    # one if its already provided.
    attrs = Map.merge(%{app_id: Ecto.UUID.generate()}, attrs)

    with {:ok, %{app_id: app_id}} <-
           OriginationApp.validate_origination_app(%OriginationApp{}, attrs),
         :ok <- OriginationApp.dispatch_create_origination_app(attrs),
         new_orig_app <- Repo.get_by(OriginationApp, app_id: app_id) do
      {:ok, new_orig_app}
    else
      {:error, _term} = err -> err
    end
  end

  @doc """
  Given the app ID of an origination application, finds the application in
  the read projection, assuming one exists.   If no matching application
  exists, returns nil
  """
  def find_origination_app_by_app_id(app_id) do
    Repo.get_by(OriginationApp, app_id: app_id)
  end

  @doc """
  Given an applicant_id, attempts to find an existing, active
  application associatd with the applicant.   If one is found,
  it is returned.  If none is found, creates a new orig application
  for the applicant and returns it.
  """
  def find_active_app_for_applicant(applicant_id) do
    Repo.get_by(OriginationApp, ssn: applicant_id)
  end

  @doc """
  Given an application id, returns the application, with all child data
  preloaded
  """
  def find_full_origination_app(app_id) do
    app_id
    |> find_origination_app_by_app_id()
    |> Repo.preload(:applicant_profile)
    |> Repo.preload(:financial_profile)
  end

  @doc """
  Given an app ID, marks an origination application as rejected,
  assuming one exists.  If no app exists or the app has
  previously been rejected, returns an {:error, err_term}
  tuple indicating the error condition.
  """
  def reject_origination_app(app_id) do
    reject = RejectOriginationApp.new(app_id)
    Orig.Events.Application.dispatch(reject, consistency: :strong)
  end

  def change_origination_app(%OriginationApp{} = origination_app, attrs \\ %{}) do
    OriginationApp.changeset(origination_app, attrs)
  end

  #### Applicant Profile

  @doc """
  Returns the list of applicant profiles.
  """
  def list_applicant_profiles() do
    Repo.all(ApplicantProfile)
  end

  @doc """
  Given an application ID, find the applicant profile record associated with it.
  If no such profile exists, return nil.
  """
  def find_applicant_profile_by_app_id(app_id) do
    Repo.get_by(ApplicantProfile, app_id: app_id)
  end

  @doc """
  Creates a applicant profile.  The application id to create the profile for must
  be included within the supplied attrs, using key `app_id`.  Returns either the
  newly created applicant profile, or an {:error, error_term} tuple if the supplied
  attr map is invalid or if a applicant profile already exists for the specified id.
  """
  def create_applicant_profile(attrs) do
    persist_applicant_profile(%ApplicantProfile{}, attrs, "create")
  end

  @doc """
  Updates an existing appliant profile.  Behaves similarly to create_applicant_profile,
  including required app_id and success/error semantics.
  """
  def update_applicant_profile(%ApplicantProfile{} = app_profile, attrs) do
    persist_applicant_profile(app_profile, attrs, "update")
  end

  defp persist_applicant_profile(
         %ApplicantProfile{} = app_profile,
         attrs,
         persistence
       ) do
    with {:ok, %ApplicantProfile{app_id: app_id}} <-
           ApplicantProfile.validate_app_profile(app_profile, attrs),
         :ok <-
           ApplicantProfile.dispatch_applicant_profile_persistence(
             AtomicMap.convert(attrs),
             persistence
           ),
         ap <- find_applicant_profile_by_app_id(app_id) do
      {:ok, ap}
    else
      {:error, _term} = err ->
        Logger.error("Problem while persisting applicant profile: #{inspect(err)}")
        err
    end
  end

  def change_applicant_profile(%ApplicantProfile{} = applicant_profile, attrs \\ %{}) do
    ApplicantProfile.changeset(applicant_profile, attrs)
  end

  #### Financial Profile
  def create_financial_profile(attrs) do
    persist_financial_profile(%FinancialProfile{}, attrs, "create")
  end

  def update_financial_profile(financial_profile, attrs) do
    persist_financial_profile(financial_profile, attrs, "update")
  end

  defp persist_financial_profile(financial_profile, attrs, persistence) do
    with cs <- change_financial_profile(financial_profile, attrs),
         {:ok, %FinancialProfile{app_id: app_id}} <-
           Ecto.Changeset.apply_action(cs, :validate),
         :ok <-
           FinancialProfile.dispatch_financial_profile_persistence(
             AtomicMap.convert(attrs),
             persistence
           ),
         %FinancialProfile{} = new_financial_profile <-
           find_financial_profile_by_app_id(app_id) do
      {:ok, new_financial_profile}
    end
  end

  def find_financial_profile_by_app_id(app_id),
    do: Repo.get_by(FinancialProfile, app_id: app_id)

  def list_financial_profiles() do
    Repo.all(FinancialProfile)
  end

  def change_financial_profile(%FinancialProfile{} = financial_profile, attrs \\ %{}) do
    FinancialProfile.changeset(financial_profile, attrs)
  end
end
