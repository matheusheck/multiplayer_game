defmodule MultiplayerGameWeb.Plug.AssignSession do
  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, _} <- MultiplayerGame.Game.State.maybe_start_game() do
      case Plug.Conn.get_session(conn, :id) do
        nil ->
          put_session(conn)

        player_id ->
          conn
      end
    end
  end

  defp put_session(conn) do
    %{id: id, name: name} = player = MultiplayerGame.Player.create()

    conn =
      conn
      |> Plug.Conn.put_session(:unique_name, name)
      |> Plug.Conn.put_session(:id, id)

    conn
  end
end
