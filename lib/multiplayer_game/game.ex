defmodule MultiplayerGame.Game do
  @derive Jason.Encoder
  defstruct players: %{},
            fruits: %{},
            screen: %{width: 10, height: 10},
            current_player: nil,
            pid: nil,
            is_adding_fruit?: false

  use Agent

  alias MultiplayerGame.Fruit

  @doc """
  Iniciate the state with Game struct
  """
  def start_game() do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def stop_game() do
    Agent.stop(__MODULE__)
  end

  def state do
    Agent.get(__MODULE__, & &1)
  end

  def reset_state() do
    Agent.stop(__MODULE__)
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
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
      fruit = Fruit.create()
      %{state | fruits: Map.put(state.fruits, fruit.id, fruit)}
    end)

    notify_new_state()
  end

  def remove_fruit(fruit_id) do
    Agent.update(__MODULE__, fn state ->
      new_fruits = Map.delete(state.fruits, fruit_id)
      %{state | fruits: new_fruits}
    end)

    notify_new_state()
  end

  def start_adding_fruit do
    Agent.update(__MODULE__, fn state ->
      %{state | is_adding_fruit?: true}
    end)

    fruit_adder()
    notify_new_state()
  end

  def stop_adding_fruit do
    Agent.update(__MODULE__, fn state ->
      %{state | is_adding_fruit?: false}
    end)

    notify_new_state()
  end

  def fruit_adder do
    spawn(fn ->
      %{is_adding_fruit?: is_adding_fruit?} = state()
      maybe_add_fruit(is_adding_fruit?)
      Process.sleep(2000)
      %{is_adding_fruit?: still_adding_fruit?} = state()
      if still_adding_fruit?, do: fruit_adder()
    end)
  end

  def keep_fruit_adder?() do
    %{is_adding_fruit?: is_adding_fruit?} = state()
    if is_adding_fruit?, do: fruit_adder()
  end

  def move_player(%{"keyPressed" => keyPressed, "playerId" => player_id}) do
    state = state()

    state
    |> get_player(player_id)
    |> maybe_move_player(state, keyPressed)
  end

  def move_player(_), do: state()

  defp check_fruit_colision(fruits, %{x: x, y: y} = _player) do
    fruits
    |> get_same_position_fruits(x, y)
    |> maybe_remove_fruit(fruits)
  end

  def get_same_position_fruits(fruits, x, y),
    do: for({id, fruit} <- fruits, fruit != nil && fruit.x == x && fruit.y == y, do: id)

  defp get_player(state, player_id) do
    state
    |> Map.get(:players)
    |> Map.get(player_id)
  end

  defp maybe_remove_fruit([id_to_remove | _], fruits), do: Map.delete(fruits, id_to_remove)
  defp maybe_remove_fruit(_, fruits), do: fruits

  defp maybe_move_player(%{y: y} = player, state, "ArrowDown") when y < 9,
    do: update_player_on_state(%MultiplayerGame.Player{player | y: y + 1}, state)

  defp maybe_move_player(%{y: y} = player, state, "ArrowUp") when y > 0,
    do: update_player_on_state(%MultiplayerGame.Player{player | y: y - 1}, state)

  defp maybe_move_player(%{x: x} = player, state, "ArrowLeft") when x > 0,
    do: update_player_on_state(%MultiplayerGame.Player{player | x: x - 1}, state)

  defp maybe_move_player(%{x: x} = player, state, "ArrowRight") when x < 9,
    do: update_player_on_state(%MultiplayerGame.Player{player | x: x + 1}, state)

  defp maybe_move_player(_player, state, _key_pressed), do: state

  defp update_player_on_state(player, state) do
    other_players = Map.delete(state.players, player.id)
    # add score to player
    new_players = Map.put(other_players, player.id, player)
    fruits = check_fruit_colision(state.fruits, player)

    Agent.update(__MODULE__, fn state ->
      %{state | players: new_players, fruits: fruits}
    end)

    notify({:new_state, state()})
  end

  defp maybe_add_fruit(is_adding_fruit?)
  defp maybe_add_fruit(true), do: add_fruit()
  defp maybe_add_fruit(_), do: nil

  def subscribe() do
    Phoenix.PubSub.subscribe(MultiplayerGame.PubSub, "game:123")
  end

  def notify({topic, state}) do
    Phoenix.PubSub.broadcast(MultiplayerGame.PubSub, "game:123", {topic, state})
  end

  def notify_new_state, do: notify({:new_state, state()})
end
