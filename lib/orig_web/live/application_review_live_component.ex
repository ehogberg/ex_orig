defmodule OrigWeb.ApplicationReviewLiveComponent do
  @moduledoc """
  The final page of the application process; provides a last chance to review
  the application and then permits the applicant to submit it for evaluation.
  """

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
    assign(socket, :origination_app, Originations.find_full_origination_app(app_id))
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

      <.personal_information
        applicant_profile={@origination_app.applicant_profile} />

      <.financial_information
        financial_profile={@origination_app.financial_profile} />

    </section>
    """
  end

  defp personal_information(assigns) do
    ~H"""
    <.section_header>Your Personal Information</.section_header>
    <.summary_text_line label="Your Name">
      <%= String.trim(@applicant_profile.first_name) %>
      <%= @applicant_profile.last_name %>
    </.summary_text_line>
    <.summary_text_line label="Your Address">
      <%= @applicant_profile.address1 %>
      <%= @applicant_profile.address2 %><br>
      <%= String.trim(@applicant_profile.city)%>
      ,
      <%= @applicant_profile.state %>
      <%= @applicant_profile.postcode %>
    </.summary_text_line>
    """
  end

  defp financial_information(assigns) do
    ~H"""
    <.section_header class="mt-10">Your Financial Information</.section_header>
    <.summary_text_line label="Your Primary Income">
      &#36;<%= @financial_profile.periodic_income %>
    </.summary_text_line>
    <.summary_text_line label="Your Pay Frequency">
      <%= @financial_profile.pay_period %>
    </.summary_text_line>
    """
  end
end
