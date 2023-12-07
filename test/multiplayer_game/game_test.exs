defmodule MultiplayerGame.GameTest do
  alias MultiplayerGame.Game
  alias MultiplayerGame.Game.State
  use ExUnit.Case

  setup do
    # Set up any necessary data or state before each test

    State.start_game()
    {:ok, state: State.get()}
  end

  @tag :focus
  test "maybe_add_player/2 adds a new player to the state" do
    player = %{id: "player1", name: "Alice"}
    new_state = Game.maybe_add_player(player)
    # FIX new_state = :ok rn

    assert Map.has_key?(new_state.players, "player1")
    assert new_state.players["player1"] == player
  end
end
