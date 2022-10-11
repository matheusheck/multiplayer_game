defmodule MultiplayerGame.Fruit do
  @derive Jason.Encoder
  defstruct x: nil, y: nil, id: nil

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
end
