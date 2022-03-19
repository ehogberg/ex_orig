defmodule Orig.Events.OriginationApp.OriginationAppCreated do
  @derive Jason.Encoder

  defstruct [:app_id, :ssn]
end
