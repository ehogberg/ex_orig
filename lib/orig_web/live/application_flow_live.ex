defmodule OrigWeb.ApplicationFlowLive do
  use OrigWeb, :live_view

  @impl true
  def mount(params, _sess, socket) do
    {:ok,
     socket
     |> assign_application_id(params["app_id"])
     |> assign_screen_flow(socket.assigns.live_action)}
  end

  defp assign_application_id(socket, app_id) do
    assign(socket, :app_id, app_id)
  end

  defp assign_screen_flow(socket, step) do
    {module, component_id} = screen_flow(step)
    assign(socket, %{module: module, component_id: component_id})
  end

  defp screen_flow(step) do
    %{
      applicant_profile: {OrigWeb.ApplicantProfileLiveComponent, "applicant_profile"},
      financial_profile: {OrigWeb.FinancialProfileLiveComponent, "financial_profile"},
      application_review: {OrigWeb.ApplicationReviewLiveComponent, "application_review"}
    }
    |> Map.get(step)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.live_component module={@module} id={@component_id}, app_id={@app_id} </>
    """
  end
end
