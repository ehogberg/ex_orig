defmodule OrigWeb.ApplyLive do
  use OrigWeb, :live_view
  alias Orig.Originations
  alias Orig.Originations.OriginationApp
  alias Ecto.Changeset

  @impl true
  def mount(_params, _sess, socket) do
    {:ok, assign_changeset(socket)}
  end

  defp assign_changeset(socket),
    do: assign(socket, :changeset, changeset())

  defp changeset(attrs \\ %{}) do
    types = %{ssn: :string}

    {%{}, types}
    |> Changeset.cast(attrs, Map.keys(types))
    |> Changeset.validate_required(:ssn)
    |> Changeset.validate_length(:ssn, is: 9)
  end

  @impl true
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <p class="text-3xl bold mb-10">Apply</p>
    <p class="mb-1">Enter a 9-character string below to get started. </p>
    <p class="mb-1">This will be used to identify your loan application.</p>
    <p class="mb-4">Do NOT use your SSN or any other string that could identify you!</p>

    <.form let={f} id="lookup-form" for={@changeset} phx-change="validate"
      phx-submit="lookup-app" as="lookup">
      <div class="mb-4">
        <%= text_input f, :ssn %>
        <div class="mt-5">
          <%= error_tag f, :ssn  %>
        </div>
      </div>

      <%= submit "Start/Continue Application",
        disabled: !(@changeset.valid?),
        class: "btn btn-blue" %>
    </.form>
    """
  end

  @impl true
  def handle_event("validate", %{"lookup" => lookup}, socket) do
    cs =
      lookup
      |> changeset()
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, cs)}
  end

  @impl true
  def handle_event("lookup-app", %{"lookup" => lookup}, socket) do
    with {:ok, %{ssn: ssn}} <-
           lookup
           |> changeset()
           |> Ecto.Changeset.apply_action(:validate),
         %OriginationApp{app_id: app_id} <-
           find_or_create_origination_app(ssn) do
      {:noreply,
       push_redirect(socket,
         to: Routes.application_flow_path(socket, :applicant_profile, app_id)
       )}
    else
      {:error, %Ecto.Changeset{} = cs} ->
        {:noreply, assign(socket, :changeset, cs)}
    end
  end

  defp find_or_create_origination_app(applicant_id) do
    curr_app = Originations.find_active_app_for_applicant(applicant_id)

    if curr_app do
      curr_app
    else
      {:ok, new_app} = Originations.create_origination_app(%{ssn: applicant_id})
      new_app
    end
  end
end
