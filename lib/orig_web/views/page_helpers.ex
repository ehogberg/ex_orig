defmodule OrigWeb.Views.PageHelpers do
  use OrigWeb, :component

  def page_header(assigns) do
    ~H"""
    <h1 class="bold text-2xl text-emerald-900 mb-5"><%= render_slot(@inner_block) %></h1>
    """
  end

  def text_entry(assigns) do
    assigns = assign(assigns, :field, String.to_atom(assigns.field))

    ~H"""
      <div class="mb-4">
        <%= label(@f, @field, class: "align-top inline-block w-36")%>
        <%= text_input @f, @field %>
        <%= error_tag @f, @field%>
      </div>
    """
  end

  def select(assigns) do
    assigns = assign(assigns, :field, String.to_atom(assigns.field))

    ~H"""
      <div class="mb-4">
        <%= label @f, @field, class: "align-top inline-block w-36" %>
        <%= select @f, @field, @opts %>
        <%= error_tag @f, @field %>
      </div>
    """
  end

  def form_submit(assigns) do
    attribs = assigns_to_attributes(assigns, [:class])

    class = "font-bold py-2 px-4 rounded bg-emerald-500 text-white " <>
      "disabled:bg-gray-300 hover:bg-emerald-700 " <>
      Map.get(assigns, :class, "")

    assigns = assigns
    |> assign(:attribs, attribs)
    |> assign(:class, class)

    ~H"""
      <input type="submit" class={@class}
        value={render_slot(@inner_block)} {@attribs} />
    """
  end
end
