defmodule OrigWeb.Views.PageHelpers do
  use OrigWeb, :component

  def page_header(assigns) do
    ~H"""
    <h1 class="bold text-2xl"><%= render_slot(@inner_block) %></h1>
    """
  end

  def text_entry(assigns) do
    assigns = assign(assigns, :field, String.to_atom(assigns.field))

    ~H"""
    <div>
      <div class="mb-4">
        <%= label @f, @field %>: <%= text_input @f, @field %>
      </div>
      <div class="mt-5">
        <%= error_tag @f, @field  %>
      </div>
    </div>
    """
  end

  def select(assigns) do
    assigns = assign(assigns, :field, String.to_atom(assigns.field))

    ~H"""
    <div>
      <div class="mb-4">
        <%= label @f, @field %>: <%= select @f, @field, @opts %>
      </div>
      <div class="mt-5">
        <%= error_tag @f, @field %>
      </div>
    </div>
    """
  end
end
