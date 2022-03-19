defmodule OrigWeb.PageController do
  use OrigWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
