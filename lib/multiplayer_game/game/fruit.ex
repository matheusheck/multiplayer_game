defmodule MultiplayerGame.Fruit do
  @derive Jason.Encoder

  defstruct x: nil, y: nil, id: nil

  alias MultiplayerGame.Game.State
  alias MultiplayerGame.Fruit

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
      x: Enum.random(0..10),
      y: Enum.random(0..10),
      id: UUID.uuid4()
    }
  end

  def add_fruit() do
    state = State.get()
    fruit = Fruit.create()
    fruits = Map.put(state.fruits, fruit.id, fruit)

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
    fruit_adder()
    State.notify_new_state()
  end

  def stop_adding_fruit do
    State.update_state(:is_adding_fruit?, false)
    State.notify_new_state()
  end

  def fruit_adder do
    spawn(fn ->
      %{is_adding_fruit?: is_adding_fruit?} = State.get()
      maybe_add_fruit(is_adding_fruit?)
      Process.sleep(2000)
      %{is_adding_fruit?: still_adding_fruit?} = State.get()
      if still_adding_fruit?, do: fruit_adder()
    end)
  end

  def keep_fruit_adder?() do
    %{is_adding_fruit?: is_adding_fruit?} = State.get()
    if is_adding_fruit?, do: fruit_adder()
  end

  defp maybe_add_fruit(is_adding_fruit?)
  defp maybe_add_fruit(true), do: add_fruit()
  defp maybe_add_fruit(_), do: nil
end
