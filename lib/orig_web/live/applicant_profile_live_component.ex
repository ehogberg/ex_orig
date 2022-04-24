defmodule OrigWeb.ApplicantProfileLiveComponent do
  @moduledoc """
  Live component providing editing/persistence for the applicant personal
  information profile portion of an origination application.
  """
  use OrigWeb, :live_component
  import OrigWeb.Views.PageHelpers
  require Logger

  alias Orig.Originations
  alias Orig.Originations.ApplicantProfile

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_applicant_profile_and_changeset(assigns.app_id)}
  end

  defp assign_applicant_profile_and_changeset(socket, app_id) do
    app_profile =
      case Originations.find_applicant_profile_by_app_id(app_id) do
        %ApplicantProfile{} = ap -> ap
        nil -> %ApplicantProfile{}
      end

    assign(
      socket,
      %{
        applicant_profile: app_profile,
        changeset: Originations.change_applicant_profile(app_profile)
      }
    )
  end

  @impl true
  def handle_event("validate", %{"applicant_profile" => attrs}, socket) do
    validated_cs =
      socket.assigns.applicant_profile
      |> Originations.change_applicant_profile(attrs)
      |> Map.put(:action, :validation)

    {:noreply, assign(socket, :changeset, validated_cs)}
  end

  def handle_event("save", %{"applicant_profile" => attrs}, socket) do
    applicant_profile = socket.assigns.applicant_profile
    applicant_profile_state = Ecto.get_meta(applicant_profile, :state)
    attrs_with_app_id = Map.put(attrs, "app_id", socket.assigns.app_id)

    case persist_applicant_profile(applicant_profile, attrs_with_app_id, applicant_profile_state) do
      {:ok, %ApplicantProfile{}} ->
        {:noreply,
         push_redirect(socket,
           to: Routes.application_flow_path(socket, :financial_profile, socket.assigns.app_id)
         )}

      {:error, cs} ->
        {:noreply, assign(socket, :changeset, cs)}
    end
  end

  defp persist_applicant_profile(_app_prof, params, :built),
    do: Originations.create_applicant_profile(params)

  defp persist_applicant_profile(app_prof, params, :loaded),
    do: Originations.update_applicant_profile(app_prof, params)

  @impl true
  def render(assigns) do
    ~H"""
    <section>
      <.page_header>Applicant Profile</.page_header>
      <.form let={f} for={@changeset} phx-change="validate"
        phx-submit="save" phx-target={@myself}>
        <.text_entry f={f} field="first_name" />
        <.text_entry f={f} field="last_name" />
        <.text_entry f={f} field="address1" />
        <.text_entry f={f} field="address2" />
        <.text_entry f={f} field="city" />
        <.text_entry f={f} field="state" />
        <.text_entry f={f} field="postcode" />
        <.form_submit>Save Applicant Profile Information</.form_submit>
      </.form>
    </section>
    """
  end
end
