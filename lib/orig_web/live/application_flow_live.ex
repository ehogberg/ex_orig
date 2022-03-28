defmodule OrigWeb.ApplicationFlowLive do
  use OrigWeb, :live_view

  @impl true
  def mount(params, _sess, socket) do
    {:ok,
     socket
     |> assign_application_id(params["app_id"])}
  end

  defp assign_application_id(socket, app_id) do
    assign(socket, :app_id, app_id)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%= if @live_action == :applicant_profile do %>
      <.live_component module={OrigWeb.ApplicantProfileLiveComponent} id={@app_id} />
    <% end %>
    """
  end
end
