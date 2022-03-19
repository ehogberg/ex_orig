defmodule Orig.Events.CommandHandlers do
  @behaviour Commanded.Commands.Handler

  alias Orig.Events.OriginationApp.{CreateOriginationApp,OriginationAppCreated}
  alias Orig.Originations.OriginationApp

  def handle(%OriginationApp{} = _agg, %CreateOriginationApp{} = create) do
    struct(OriginationAppCreated, Map.from_struct(create))
  end
end
