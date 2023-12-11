defmodule MultiplayerGame.Game.StateTest do
  use ExUnit.Case
  alias MultiplayerGame.Game.State
  # Add this line if your mock module is in the same project or adjust accordingly
  alias PubSubMock

  @moduletag :focus
  setup do
    {:ok, _pid} = State.start_game()
    :ok
  end

  test "initial state has default values" do
    state = State.get()

    assert %MultiplayerGame.Game.State{
             players: %{},
             fruits: %{},
             screen: %{width: 10, height: 10},
             current_player: nil,
             pid: _,
             is_adding_fruit?: false
           } = state
  end

  test "update_state/2 updates the state" do
    {:ok, new_state} = State.update_state(:current_player, "Player1")

    assert %MultiplayerGame.Game.State{
             players: %{},
             fruits: %{},
             screen: %{width: 10, height: 10},
             current_player: "Player1",
             pid: _,
             is_adding_fruit?: false
           } = new_state
  end
end
