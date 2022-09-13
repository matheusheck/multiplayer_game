defmodule MultiplayerGame.Game do
  @derive Jason.Encoder
  defstruct players: %{}, fruits: %{}, screen: %{width: 10, height: 10}, current_player: nil

  use Agent

  alias MultiplayerGame.Fruit

  @doc """
  Iniciate the state with Game struct
  """
  def start_link(initial_state) do
    IO.inspect("INICIOU")
    # initial_state = %__MODULE__{}
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def state do
    Agent.get(__MODULE__, & &1)
  end

  def add_player(%{id: id} = player) do
    Agent.update(__MODULE__, fn state ->
      new_players = Map.put(state.players, id, player)
      %{state | players: new_players}
    end)
  end

  def remove_player(player_id) do
    Agent.update(__MODULE__, fn state ->
      new_players = Map.delete(state.players, player_id)
      %{state | players: new_players}
    end)
  end

  def add_fruit() do
    Agent.update(__MODULE__, fn state ->
      new_fruits = Map.put(state.fruits, %Fruit{})
      %{state | fruits: new_fruits}
    end)
  end


  def remove_fruit(fruit_id) do
    Agent.update(__MODULE__, fn state ->
      new_fruits = Map.delete(state.fruits, fruit_id)
      %{state | fruits: new_fruits}
    end)
  end

  def move_player(command) do
    maybe_move_player(command)
  end

  def maybe_move_player(%{"keyPressed" => "ArrowDown", "playerId" => player_id}) do
    players_state = state()

    Agent.update(__MODULE__, fn state ->
      %{players: players} = state
      this_player = players[player_id]
      other_players = Map.delete(state.fruits, player_id)
      new_this_player = %{}
      new_players = Map.put(other_players, new_this_player)

      %{state | players: new_players}
    end)
  end
end
