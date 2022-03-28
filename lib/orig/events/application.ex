defmodule Orig.Events.Application do
  use Commanded.Application, otp_app: :orig
  alias Orig.Events.OrigApplicationRouter

  router(OrigApplicationRouter)
end
