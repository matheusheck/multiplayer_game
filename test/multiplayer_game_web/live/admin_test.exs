defmodule MultiplayerGameWeb.Live.AdminTest do
  use MultiplayerGameWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/admin")
    assert html_response(conn, 200) =~ "Admin"
  end
end
