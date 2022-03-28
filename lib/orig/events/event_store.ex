defmodule Orig.Events.EventStore do
  use EventStore, otp_app: :orig, schema: "events"
end
