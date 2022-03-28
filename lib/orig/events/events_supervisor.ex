defmodule Orig.Events.EventsSupervisor do
  use Supervisor

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end


  def init(_arg) do
    children = [
      Orig.Events.Application,
      Orig.Events.OriginationApp.OriginationAppProjector,
      Orig.Events.ApplicantProfile.ApplicantProfileProjector
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

end
