defmodule OrigWeb.Views.PageHelpers do
  use OrigWeb, :component

  def page_header(assigns) do
    ~H"""
    <h1 class="bold text-2xl"><%= render_slot(@inner_block) %></h1>
    """
  end
end
