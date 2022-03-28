defmodule Orig.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Orig.Repo,
      # Start the Telemetry supervisor
      OrigWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Orig.PubSub},
      # Start the Endpoint (http/https)
      OrigWeb.Endpoint,
      Orig.Events.EventsSupervisor
      # Start a worker by calling: Orig.Worker.start_link(arg)
      # {Orig.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Orig.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OrigWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
