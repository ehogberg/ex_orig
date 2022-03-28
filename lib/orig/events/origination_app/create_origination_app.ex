defmodule Orig.Events.OriginationApp.CreateOriginationApp do
  defstruct app_id: nil, ssn: nil

  def new(attrs) do
    struct(__MODULE__, attrs)
  end
end
