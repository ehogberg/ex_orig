defmodule OrigWeb.Views.PageHelpers do
  use OrigWeb, :component

  def page_header(assigns) do

    class = "bold text-2xl text-emerald-900 mb-5 " <>
      Map.get(assigns, :class, "")
    attribs = assigns_to_attributes(assigns, [:class])

    assigns = assigns
    |> assign(:attribs, attribs)
    |> assign(:class, class)

    ~H"""
    <h1 class={@class} {@attribs}><%= render_slot(@inner_block)%></h1>
    """
  end

  def section_header(assigns) do
    class = "bold text-xl text-emerald-500 mb-5 " <>
      Map.get(assigns, :class, "")
    attribs = assigns_to_attributes(assigns, [:class])

    assigns = assigns
    |> assign(:attribs, attribs)
    |> assign(:class, class)

    ~H"""
    <h2 class={@class} {@attribs}><%= render_slot(@inner_block) %></h2>
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

  def page_text(assigns) do
    class = "mb-5 " <> Map.get(assigns, :class, "")
    attribs = assigns_to_attributes(assigns, [:class])

    assigns = assigns
    |> assign(:attribs, attribs)
    |> assign(:class, class)

    ~H"""
    <p class={@class} {@attribs}><%= render_slot(@inner_block) %></p>
    """
  end

  def summary_text_line(assigns) do
    ~H"""
    <div class="mb-2">
      <span class="inline-block align-top font-bold w-40"><%= @label %></span>
      <span class="inline-block"><%= render_slot(@inner_block) %></span>
    </div>
    """
  end

end
