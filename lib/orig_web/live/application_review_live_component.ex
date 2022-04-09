defmodule OrigWeb.ApplicationReviewLiveComponent do
  use OrigWeb, :live_component
  import OrigWeb.Views.PageHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <section>
      <.page_header>Application Review</.page_header>
    </section>
    """
  end
end
