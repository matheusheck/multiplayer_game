defmodule MultiplayerGameWeb.Plug.AssignSession do
  alias MultiplayerGame.Game
  alias MultiplayerGame.Players

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, _} <- Game.State.maybe_start_game() do
      conn
      |> Plug.Conn.get_session(:id)
      |> maybe_put_session(conn)
    end
  end

  defp maybe_put_session(nil, conn) do
    {:ok, %{name: name, id: id}} =
      Players.create_player(%{name: MultiplayerGame.Names.generate()})

    Game.Player.create(%{name: name, id: id})

    conn =
      conn
      |> Plug.Conn.put_session(:unique_name, name)
      |> Plug.Conn.put_session(:id, id)

    conn
  end

  defp maybe_put_session(_, conn), do: conn
end
