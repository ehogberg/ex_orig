defmodule Orig.Events.OrigApplication do
  use Commanded.Application,
    otp_app: :orig,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Orig.Events.EventStore
    ]
end
