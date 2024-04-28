defmodule MultiplayerGame.GameStates.GameState do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "game_states" do
    belongs_to(:game_instance, MultiplayerGame.GameInstance)
    has_many(:player_positions, MultiplayerGame.StatePlayerPosition)
    has_many(:fruit_positions, MultiplayerGame.StateFruitPosition)

    timestamps()
  end

  def changeset(game_state, attrs) do
    game_state
    |> cast(attrs, [])
  end
end
