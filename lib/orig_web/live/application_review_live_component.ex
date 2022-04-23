defmodule OrigWeb.ApplicationReviewLiveComponent do
  use OrigWeb, :live_component
  alias Orig.Originations
  import OrigWeb.Views.PageHelpers

  @impl true
  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign_application(assigns.app_id)}
  end

  defp assign_application(socket, app_id) do
    assign(socket, :origination_app,
      Originations.find_full_origination_app(app_id))
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section>
      <.page_header>Review And Submit Your Application</.page_header>

      <.page_text class="mb-7">
        Carefully review the information below before submitting your application.
        Once your application is submitted, you cannot make changes to it.
      </.page_text>

      <.section_header>Your Personal Information</.section_header>
      <.summary_text_line label="Your Name">
        <%= String.trim(@origination_app.applicant_profile.first_name) %>
        <%= @origination_app.applicant_profile.last_name %>
      </.summary_text_line>
      <.summary_text_line label="Your Address">
        <%= @origination_app.applicant_profile.address1 %>
        <%= @origination_app.applicant_profile.address2 %><br>
        <%= String.trim(@origination_app.applicant_profile.city)%>
        ,
        <%= @origination_app.applicant_profile.state %>
        <%= @origination_app.applicant_profile.postcode %>
      </.summary_text_line>

      <.section_header class="mt-10">Your Financial Information</.section_header>
    </section>
    """
  end
end
