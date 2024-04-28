defmodule MultiplayerGame.PlayersTest do
  use MultiplayerGame.RepoCase
  alias MultiplayerGame.Players

  test "create_player/1" do
    player_attrs = %{name: "Alice"}

    {:ok, player} = Players.create_player(player_attrs)

    assert %MultiplayerGame.Players.Player{} = player
    assert player.name == "Alice"
  end
end
