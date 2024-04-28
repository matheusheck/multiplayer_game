defmodule MultiplayerGame.GameInstances.GameInstance do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "game_instances" do
    many_to_many(:players, MultiplayerGame.Players.Player, join_through: "game_instance_players")
    has_many(:game_states, MultiplayerGame.GameStates.GameState)

    timestamps()
  end

  def changeset(game_instance, attrs) do
    game_instance
    |> cast(attrs, [])
  end
end
