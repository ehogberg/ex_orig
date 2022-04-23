defmodule OrigWeb.FinancialProfileLiveComponent do
  use OrigWeb, :live_component
  import OrigWeb.Views.PageHelpers

  alias Orig.Originations
  alias Orig.Originations.FinancialProfile
  alias Orig.Originations.FinancialProfile.PayPeriod

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_financial_profile_and_changeset(assigns.app_id)}
  end

  defp assign_financial_profile_and_changeset(socket, app_id) do
    financial_profile =
      case Originations.find_financial_profile_by_app_id(app_id) do
        %FinancialProfile{} = fp -> fp
        nil -> %FinancialProfile{}
      end

    assign(socket, %{
      financial_profile: financial_profile,
      changeset: Originations.change_financial_profile(financial_profile)
    })
  end

  @impl true
  def handle_event("validate", %{"financial_profile" => attrs}, socket) do
    cs =
      socket.assigns.financial_profile
      |> Originations.change_financial_profile(attrs)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, cs)}
  end

  @impl true
  def handle_event("save", %{"financial_profile" => attrs}, socket) do
    financial_profile = socket.assigns.financial_profile
    state = Ecto.get_meta(financial_profile, :state)
    attrs = Map.put(attrs, "app_id", socket.assigns.app_id)

    case persist_financial_profile(financial_profile, attrs, state) do
      {:ok, _financial_profile} ->
        {:noreply,
         push_redirect(socket,
           to: Routes.application_flow_path(socket, :application_review, socket.assigns.app_id)
         )}

      {:error, %Ecto.Changeset{} = cs} ->
        {:noreply, assign(socket, :changeset, cs)}
    end
  end

  defp persist_financial_profile(_, attrs, :built),
    do: Originations.create_financial_profile(attrs)

  defp persist_financial_profile(financial_profile, attrs, :loaded),
    do: Originations.update_financial_profile(financial_profile, attrs)

  @impl true
  def render(assigns) do
    ~H"""
    <section>
      <.page_header>Financial Profile</.page_header>
      <.form let={f} for={@changeset} phx-target={@myself}
        phx-change="validate" phx-submit="save">
        <.text_entry f={f} field="periodic_income" />
        <.select f={f} field="pay_period" opts={PayPeriod.__enums__}/>
        <.text_entry f={f} field="primary_routing_number" />
        <.text_entry f={f} field="primary_account_number" />
        <.form_submit disabled={!(@changeset.valid?)}>Save Financial Profile Information</.form_submit>
      </.form>
    </section>
    """
  end
end
