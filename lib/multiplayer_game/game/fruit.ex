defmodule MultiplayerGame.Fruit do
  @derive Jason.Encoder

  defstruct x: nil, y: nil, id: nil

  alias MultiplayerGame.Game.State

  @type t() :: %__MODULE__{
          x: integer(),
          y: integer(),
          id: String.t()
        }

  @doc """
  Iniciate the state with Game struct
  """
  def create() do
    %__MODULE__{
      x: Enum.random(0..7),
      y: Enum.random(0..7),
      id: UUID.uuid4()
    }
  end

  def add_fruit() do
    %{fruits: fruits} = State.get()
    new_fruit = create()

    same_position_fruits =
      for(
        {id, fruit_position} <- fruits,
        fruit_position.x == new_fruit.x && fruit_position.y == new_fruit.y,
        do: id
      )

    fruits =
      if length(same_position_fruits) == 0,
        do: Map.put(fruits, new_fruit.id, new_fruit),
        else: fruits

    State.update_state(:fruits, fruits)
    State.notify_new_state()
  end

  def remove_fruit(fruit_id) do
    %{fruits: fruits} = State.get()
    State.update_state(:fruits, Map.delete(fruits, fruit_id))
    State.notify_new_state()
  end

  def start_adding_fruit do
    State.update_state(:is_adding_fruit?, true)
    Process.sleep(5000)
    fruit_adder()
    State.notify_new_state()
  end

  def stop_adding_fruit do
    State.update_state(:fruits, %{})
    State.update_state(:is_adding_fruit?, false)
    State.notify_new_state()
  end

  def fruit_adder do
    spawn(fn ->
      %{is_adding_fruit?: is_adding_fruit?} = State.get()
      maybe_add_fruit(is_adding_fruit?, MultiplayerGame.Game.count_players())
      Process.sleep(4000)
      %{is_adding_fruit?: still_adding_fruit?} = State.get()
      if still_adding_fruit?, do: fruit_adder()
    end)
  end

  def keep_fruit_adder?() do
    %{is_adding_fruit?: is_adding_fruit?} = State.get()
    if is_adding_fruit?, do: fruit_adder()
  end

  defp maybe_add_fruit(is_adding_fruit?, number_of_players)
  defp maybe_add_fruit(true, number_of_players) when number_of_players > 1, do: add_fruit()
  defp maybe_add_fruit(_, _), do: nil
end
