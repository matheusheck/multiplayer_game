defmodule MultiplayerGame.Game do

  alias MultiplayerGame.Fruit
  alias MultiplayerGame.Game.State

  @doc """
  Iniciate the state with Game struct
  """

  def add_player(true, _), do: State.get()

  def add_player(_, %{id: id} = player) do
    state = State.get()
    State.update_state(:players, Map.put(state.players, id, player))
  end

  def maybe_add_player(%{id: id} = player) do
    State.get()
    |> Map.has_key?(id)
    |> add_player(player)
  end

  def remove_player(player_id) do
    Agent.update(__MODULE__, fn state ->
      new_players = Map.delete(state.players, player_id)
      %{state | players: new_players}
    end)
  end

  def move_player(%{"keyPressed" => keyPressed, "playerId" => player_id}) do
    state = State.get()

    state
    |> get_player(player_id)
    |> maybe_move_player(state, keyPressed)
  end

  def move_player(_), do: State.get()

  defp check_fruit_colision(fruits, %{x: x, y: y} = _player) do
    fruits
    |> get_same_position_fruits(x, y)
    |> maybe_remove_fruit(fruits)
  end

  def get_same_position_fruits(fruits, x, y) do
    for({id, fruit} <- fruits, fruit.x == x && fruit.y == y, do: id)
  end

  defp get_player(state, player_id) do
    state
    |> Map.get(:players)
    |> Map.get(player_id)
  end

  defp maybe_remove_fruit([id_to_remove | _], fruits), do:
    {:ok, Map.delete(fruits, id_to_remove)}
  defp maybe_remove_fruit(_, fruits), do: {:no_colision, fruits}

  defp maybe_move_player(%{y: y} = player, state, "ArrowDown") when y < 9,
    do: update_player_moviment_on_state(%MultiplayerGame.Player{player | y: y + 1}, state)

  defp maybe_move_player(%{y: y} = player, state, "ArrowUp") when y > 0,
    do: update_player_moviment_on_state(%MultiplayerGame.Player{player | y: y - 1}, state)

  defp maybe_move_player(%{x: x} = player, state, "ArrowLeft") when x > 0,
    do: update_player_moviment_on_state(%MultiplayerGame.Player{player | x: x - 1}, state)

  defp maybe_move_player(%{x: x} = player, state, "ArrowRight") when x < 9,
    do: update_player_moviment_on_state(%MultiplayerGame.Player{player | x: x + 1}, state)

  defp maybe_move_player(_player, state, _key_pressed), do: state

  defp update_player_moviment_on_state(player, state) do
    other_players = Map.delete(state.players, player.id)
    # add score to player
    {player_scored?, fruits} = check_fruit_colision(state.fruits, player)
    player = update_player_score(player_scored?, player)
    new_players = Map.put(other_players, player.id, player)


    State.update_state(:players, new_players)
    State.update_state(:fruits, fruits)

    State.notify_new_state()
  end

  defp update_player_score(player_scored?, player)
  defp update_player_score(:no_colision, player), do: player
  defp update_player_score(_, %{points: points} = player), do: %MultiplayerGame.Player{player | points: points + 1}
end
