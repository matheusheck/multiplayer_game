defmodule MultiplayerGame.Player do
  @derive Jason.Encoder
  defstruct x: nil, y: nil, id: nil, name: nil, points: 0

  @type t() :: %__MODULE__{
          x: integer(),
          y: integer(),
          id: String.t(),
          name: String.t()
        }

  @doc """
  Iniciate the state with Game struct
  """
  def create(%{
        id: id,
        name: name
      }) do
    %__MODULE__{
      x: Enum.random(0..7),
      y: Enum.random(0..7),
      id: id,
      name: name
    }
  end

  def create() do
    %__MODULE__{
      x: Enum.random(0..7),
      y: Enum.random(0..7),
      id: UUID.uuid4(),
      name: MultiplayerGame.Names.generate()
    }
  end
end
