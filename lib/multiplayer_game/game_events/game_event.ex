defmodule MultiplayerGame.GameEvents.GameEvent do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "game_events" do
    field(:event_type, :string)
    belongs_to(:player, MultiplayerGame.Players.Player)
    belongs_to(:game_instance, MultiplayerGame.GameInstances.GameInstance)
    belongs_to(:game_state, MultiplayerGame.GameStates.GameState)

    timestamps()
  end

  def changeset(game_event, attrs) do
    game_event
    |> cast(attrs, [:event_type, :player_id, :game_instance_id, :game_state_id])
  end
end
