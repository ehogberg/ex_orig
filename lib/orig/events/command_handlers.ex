defmodule Orig.Events.CommandHandlers do
  @behaviour Commanded.Commands.Handler

  alias Orig.Events.OriginationApp.{CreateOriginationApp,OriginationAppCreated,
    RejectOriginationApp, OriginationAppRejected}
  alias Orig.Originations.OriginationApp

  @impl true
  def handle(%OriginationApp{} = _agg, %CreateOriginationApp{} = create) do
    struct(OriginationAppCreated, Map.from_struct(create))
  end

  @impl true
  def handle(%OriginationApp{} = _app, %RejectOriginationApp{} = reject) do
    struct(OriginationAppRejected, Map.from_struct(reject))
  end
end
