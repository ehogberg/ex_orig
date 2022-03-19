defmodule Orig.Events.OriginationApp.CreateOriginationApp do
  defstruct app_id: Ecto.UUID.generate(), ssn: nil
end
