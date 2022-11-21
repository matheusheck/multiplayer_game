defmodule MultiplayerGame.Game.State do
  @derive Jason.Encoder

  defstruct players: %{},
            fruits: %{},
            screen: %{width: 10, height: 10},
            current_player: nil,
            pid: nil,
            is_adding_fruit?: false

  use Agent

  def start_game() do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def stop_game() do
    Agent.stop(__MODULE__)
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end

  def reset_state() do
    Agent.stop(__MODULE__)
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def update_state(key_to_be_updated, new_value) do
    Agent.update(__MODULE__, fn state ->
      Map.replace(state, key_to_be_updated, new_value)
    end)
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(MultiplayerGame.PubSub, "game:123")
  end

  def notify({topic, state}) do
    Phoenix.PubSub.broadcast(MultiplayerGame.PubSub, "game:123", {topic, state})
  end

  def notify_new_state, do: notify({:new_state, get()})
end
