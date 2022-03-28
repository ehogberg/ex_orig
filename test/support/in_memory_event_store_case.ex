defmodule Orig.InMemoryEventStoreCase do
  use ExUnit.CaseTemplate

  alias Commanded.EventStore.Adapters.InMemory

  setup do
    {:ok, _apps} = Application.ensure_all_started(:orig)

    on_exit( fn ->
      :ok = Application.stop(:orig)
    end)
  end
end
