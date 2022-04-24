defmodule Orig.DistilleryTasks do
  alias EventStore.Tasks.{Drop, Create, Init}

  def event_store_create(args) do
    event_store_cmd(args, :create)
  end

  def event_store_drop(args) do
    event_store_cmd(args, :drop)
  end

  def event_store_init(args) do
    event_store_cmd(args, :init)
  end

  defp event_store_cmd(_args, cmd) do
    {:ok, _} = Application.ensure_all_started(:postgrex)
    {:ok, _} = Application.ensure_all_started(:ssl)

    config = EventStore.Config.parsed(Orig.Events.EventStore, :orig)

    case cmd do
      :create -> Create.exec(config)
      :drop -> Drop.exec(config)
      :init -> Init.exec(config)
    end
  end
end
