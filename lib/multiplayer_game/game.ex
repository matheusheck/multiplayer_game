defmodule MultiplayerGame.Game do
  @derive Jason.Encoder
  defstruct players: %{}, fruits: %{}, screen: %{width: 10, height: 10}, current_player: nil, pid: nil

  use Agent

  alias MultiplayerGame.Fruit

  @doc """
  Iniciate the state with Game struct
  """
  def start_game() do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
    |> IO.inspect(label: "#{__MODULE__}.start_game()")
  end

  def stop_game() do
    Agent.stop(__MODULE__)
    |> IO.inspect(label: "#{__MODULE__}.stop_game()")
  end

  def state do
    Agent.get(__MODULE__, & &1)
  end

  def reset_state() do
    Agent.stop(__MODULE__)
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
    |> IO.inspect(label: "#{__MODULE__}.reset_state()")
  end

  def maybe_add_player(%{id: id} = player) do
    state()
    |> Map.has_key?(id)
    |> add_player(player)
  end

  def add_player(true, _), do: state()
  def add_player(_, %{id: id} = player) do
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
      new_fruits = Map.put(state, :fruits, %Fruit{})
      %{state | fruits: new_fruits}
    end)
  end

  def remove_fruit(fruit_id) do
    Agent.update(__MODULE__, fn state ->
      new_fruits = Map.delete(state.fruits, fruit_id)
      %{state | fruits: new_fruits}
    end)
  end

  def move_player(%{"keyPressed" => "ArrowDown", "playerId" => player_id}) do
    state = state()

    state
    |> get_player(player_id)
    |> maybe_move_player_down(state)
  end

  def move_player(%{"keyPressed" => "ArrowUp", "playerId" => player_id}) do
    state = state()

    state
    |> get_player(player_id)
    |> maybe_move_player_up(state)
  end

  def move_player(%{"keyPressed" => "ArrowLeft", "playerId" => player_id}) do
    state = state()

    state
    |> get_player(player_id)
    |> maybe_move_player_left(state)
  end

  def move_player(%{"keyPressed" => "ArrowRight", "playerId" => player_id}) do
    state = state()

    state
    |> get_player(player_id)
    |> maybe_move_player_right(state)
  end

  def move_player(_), do: state()

  defp get_player(state, player_id) do
    state
    |> Map.get(:players)
    |> Map.get(player_id)
  end

  defp maybe_move_player_down(%{y: y} = player, state) when y < 9, do:
    update_player_on_state(%MultiplayerGame.Player{player | y: y + 1}, state)
  defp maybe_move_player_down(_player, state), do: state

  defp maybe_move_player_up(%{y: y} = player, state) when y > 0, do:
    update_player_on_state(%MultiplayerGame.Player{player | y: y - 1}, state)
  defp maybe_move_player_up(_player, state), do: state

  defp maybe_move_player_left(%{x: x} = player, state) when x > 0, do:
  update_player_on_state(%MultiplayerGame.Player{player | x: x - 1}, state)
  defp maybe_move_player_left(_player, state), do: state

  defp maybe_move_player_right(%{x: x} = player, state) when x < 9, do:
    update_player_on_state(%MultiplayerGame.Player{player | x: x + 1}, state)
  defp maybe_move_player_right(_player, state), do: state

  defp update_player_on_state(player, state) do
    other_players = Map.delete(state.players, player.id)
    new_players = Map.put(other_players, player.id, player)

    Agent.update(__MODULE__, fn state ->
      %{state | players: new_players}
    end)

    notify({:new_state, state()})
  end

  defp update_current_player_id_on_state(current_player_id, _state) do
    Agent.update(__MODULE__, fn state ->
      %{state | current_player_id: current_player_id}
    end)
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(MultiplayerGame.PubSub, "user:123")
  end

  def notify({topic, state}) do
    Phoenix.PubSub.broadcast(MultiplayerGame.PubSub, "user:123", {topic, state})
  end

  def notify_new_state, do: notify({:new_state, state()})
end
