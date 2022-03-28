defmodule Orig.Events.OriginationApp.RejectOriginationApp do
  defstruct [:app_id]

  def new(app_id) do
    %__MODULE__{app_id: app_id}
  end
end
