defmodule MultiplayerGameWeb.Plug.AssignSession do
  def init(opts), do: opts

  def call(conn = %{session: %{id: _}}, _opts) do
    conn
  end

  def call(conn, _opts) do
    %{id: id, name: name} = player = MultiplayerGame.Player.create()
    MultiplayerGame.Game.maybe_add_player(player)

    conn =
      conn
      |> Plug.Conn.put_session(:unique_name, name)
      |> Plug.Conn.put_session(:id, id)
      |> Plug.Conn.put_session(:player, player)
    conn
  end
end
