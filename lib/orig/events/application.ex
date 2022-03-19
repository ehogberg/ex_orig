defmodule Orig.Events.Application do
  use Commanded.Application,
    otp_app: :orig,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Orig.Events.EventStore
    ]

  alias Orig.Events.OrigApplicationRouter

  router OrigApplicationRouter
end
