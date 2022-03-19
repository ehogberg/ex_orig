defmodule Orig.Events.EventsSupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end


  def init(_arg) do
    children = [
      Orig.Events.OrigApplication
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

end
