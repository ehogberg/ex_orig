defmodule Orig.Events.OrigApplicationRouter do
  use Commanded.Commands.Router

  alias Orig.Events.CommandHandlers
  alias Orig.Events.OriginationApp.{CreateOriginationApp, RejectOriginationApp}
  alias Orig.Originations.OriginationApp

  identify OriginationApp, by: :app_id

  dispatch CreateOriginationApp, to: CommandHandlers, aggregate: OriginationApp
  dispatch RejectOriginationApp, to: CommandHandlers, aggregate: OriginationApp
end
