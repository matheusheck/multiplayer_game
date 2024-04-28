defmodule MultiplayerGame.GameInstancesTest do
  use MultiplayerGame.RepoCase
  alias MultiplayerGame.GameInstances

  test "create_game_instance/1" do
    {:ok, game_instance} = GameInstances.create_game_instance()

    assert %MultiplayerGame.GameInstances.GameInstance{} = game_instance
  end
end
