defmodule OrigWeb.ApplyLive do
  use OrigWeb, :live_view
  alias Orig.Originations

  @impl true
  def mount(_params, _sess, socket) do
    {:ok, assign_changeset(socket)}
  end

  defp assign_changeset(socket),
    do: assign(socket, :changeset, changeset())

  defp changeset(attrs \\ %{}) do
    types = %{ssn: :string}

    {%{}, types}
    |> Ecto.Changeset.cast(attrs, Map.keys(types))
    |> Ecto.Changeset.validate_required(:ssn)
    |> Ecto.Changeset.validate_length(:ssn, is: 9)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <p class="text-3xl bold mb-10">Apply</p>
    <p class="mb-1">Enter a 9-character string below to get started. </p>
    <p class="mb-1">This will be used to identify your loan application.</p>
    <p class="mb-4">Do NOT use your SSN or any other string that could identify you!</p>

    <.form let={f} for={@changeset} phx-change="validate" phx-submit="lookup-app" as="lookup">
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
    cs = lookup
    |> changeset()
    |> Map.put(:action, :validate)

    {:noreply,assign(socket, :changeset, cs)}
  end

  @impl true
  def handle_event("lookup-app", %{"lookup" => lookup}, socket) do
    cs = changeset(lookup)
    IO.inspect(cs)

    case Ecto.Changeset.apply_action(cs, :lookup) do
      {:ok, %{ssn: ssn}} ->
        %{app_id: app_id} = Originations.find_or_create_origination_app(ssn)
        {:noreply,
          socket
          |> push_redirect(
            to: Routes.application_flow_path(socket,:applicant_profile, app_id))}
      {:error, cs} -> {:noreply, assign(socket, :changeset, cs)}
    end

  end
end
