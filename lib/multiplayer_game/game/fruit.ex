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
  def create(),
    do: {
      Enum.random(0..10),
      Enum.random(0..10)
    }

  def add_fruit() do
    %{fruits: fruits} = State.get()
    new_fruit = create()
    fruits = Map.put(fruits, new_fruit, :fruit_added)

    State.update_state(:fruits, fruits)
  end

  def remove_fruit(fruit) do
    %{fruits: fruits} = State.get()
    State.update_state(:fruits, Map.delete(fruits, fruit))
  end

  def start_adding_fruit do
    Process.sleep(5000)
    fruit_adder()
  end

  def fruit_adder do
    add_fruit()

    spawn(fn ->
      Process.sleep(4000)
      maybe_add_fruit(MultiplayerGame.Game.count_players())
    end)
  end

  defp maybe_add_fruit(number_of_players) when number_of_players > 1, do: fruit_adder()
  defp maybe_add_fruit(_), do: nil
end
