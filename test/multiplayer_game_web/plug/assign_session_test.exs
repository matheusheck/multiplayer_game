defmodule MultiplayerGameWeb.Plug.AssignSessionTest do
  alias Plug.Conn

  use MultiplayerGameWeb.ConnCase

  @session_options Plug.Session.init(
                     store: :cookie,
                     key: "_multiplayer_game_key",
                     signing_salt: "w4dxsV5v"
                   )
  setup do
    conn =
      build_conn()
      |> Plug.Session.call(@session_options)
      |> Conn.fetch_session()

    {:ok, conn: conn}
  end

  test "it assigns session for a new player", %{conn: conn} do
    MultiplayerGame.Game.State.start_game()

    conn = MultiplayerGameWeb.Plug.AssignSession.call(conn, [])

    %{"unique_name" => unique_name, "id" => _id} = get_session(conn)

    assert unique_name != nil
  end
end
