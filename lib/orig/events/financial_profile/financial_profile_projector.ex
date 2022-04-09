defmodule Orig.Events.FinancialProfile.FinancialProfileProjector do
  use Commanded.Projections.Ecto,
    application: Orig.Events.Application,
    repo: Orig.Repo,
    name: "financial_profile",
    consistency: :strong

  alias Orig.Events.FinancialProfile.FinancialProfileChanged
  alias Orig.Originations.FinancialProfile
  alias Orig.Repo

  alias Ecto.Multi

  project(
    %FinancialProfileChanged{
      financial_profile: financial_profile,
      persistence: "create"
    },
    fn multi ->
      cs =
        %FinancialProfile{}
        |> FinancialProfile.changeset(financial_profile)

      Multi.insert(multi, :financial_profiles, cs)
    end
  )

  project(
    %FinancialProfileChanged{
      app_id: app_id,
      financial_profile: financial_profile,
      persistence: "update"
    },
    fn multi ->
      cs =
        FinancialProfile
        |> Repo.get_by(app_id: app_id)
        |> FinancialProfile.changeset(financial_profile)

      Multi.update(multi, :financial_profiles, cs)
    end
  )

  def error({:error, _error}, _event, _ctx) do
    :skip
  end
end
