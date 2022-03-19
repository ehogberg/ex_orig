defmodule Orig.Events.OriginationApp.OriginationAppProjector do
  use Commanded.Projections.Ecto,
  application: Orig.Events.Application,
  repo:  Orig.Repo,
  name: "origination_app_projection"

  alias Orig.Events.OriginationApp.{OriginationAppCreated}
  alias Orig.Originations.OriginationApp
  alias Ecto.Multi

  project %OriginationAppCreated{} = create, fn multi ->
    cs = OriginationApp.changeset(%OriginationApp{}, Map.from_struct(create))
    Multi.insert(multi, :origination_apps, cs)
  end

  def error({:error, _error}, _event, _ctx) do
    :skip
  end

end
