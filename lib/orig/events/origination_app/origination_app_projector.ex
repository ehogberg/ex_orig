defmodule Orig.Events.OriginationApp.OriginationAppProjector do
  use Commanded.Projections.Ecto,
    application: Orig.Events.Application,
    repo: Orig.Repo,
    name: "origination_app_projection",
    consistency: :strong

  alias Orig.Events.OriginationApp.{OriginationAppCreated, OriginationAppRejected}
  alias Orig.Originations.OriginationApp
  alias Ecto.Multi
  alias Orig.Repo

  project(%OriginationAppCreated{} = create, fn multi ->
    cs = OriginationApp.changeset(%OriginationApp{}, Map.from_struct(create))
    Multi.insert(multi, :origination_apps, cs)
  end)

  project(%OriginationAppRejected{app_id: app_id}, fn multi ->
    cs =
      OriginationApp
      |> Repo.get_by(app_id: app_id)
      |> OriginationApp.reject_origination_app_changeset()

    Multi.update(multi, :origination_apps, cs)
  end)

  def error({:error, _error}, _event, _ctx) do
    :skip
  end
end
