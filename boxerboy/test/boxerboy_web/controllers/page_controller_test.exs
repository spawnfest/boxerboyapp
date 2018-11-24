defmodule BoxerboyWeb.PageControllerTest do
  use BoxerboyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "boxerboy"
  end
end
