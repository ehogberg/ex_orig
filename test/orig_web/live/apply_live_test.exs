defmodule OrigWeb.ApplyLiveTest do
  use OrigWeb.ConnCase, async: true

  test "disconnected mount", %{conn: conn} do
    conn = get(conn, "/apply")
    assert html_response(conn, 200) =~ "Apply"
  end

  test "connected mount", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/apply")
    assert html =~ "Apply"
  end

  test "tell user when applicant ID is invalid", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/apply")

    assert render_change(view, "validate", %{"lookup" => %{"ssn" => "111"}}) =~
             "should be 9 character(s)"
  end
end
