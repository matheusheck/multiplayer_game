defmodule MultiplayerGame.GameTest do
  alias MultiplayerGame.Game
  alias MultiplayerGame.Game.State
  use ExUnit.Case

  setup do
    # Set up any necessary data or state before each test

    State.start_game()
    {:ok, state: State.get()}
  end

  test "maybe_add_player/2 adds a new player to the state" do
    player = %MultiplayerGame.Game.Player{id: "player1", name: "Alice"}
    {:ok, new_state} = Game.maybe_add_player(player.id, player.name)

    assert Map.has_key?(new_state.players, "player1")
    assert %{id: id, name: name} = new_state.players[player.id]
    assert name == player.name
    assert id == player.id
  end
end
