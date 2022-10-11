defmodule MultiplayerGame.Player do
  @derive Jason.Encoder
  defstruct x: nil, y: nil, id: nil, name: nil

  @type t() :: %__MODULE__{
          x: integer(),
          y: integer(),
          id: String.t(),
          name: String.t()
        }

  @doc """
  Iniciate the state with Game struct
  """
  def create(id, name) do
    %__MODULE__{
      x: Enum.random(0..10),
      y: Enum.random(0..10),
      id: id,
      name: name
    }
  end
end
