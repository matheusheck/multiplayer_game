defmodule MultiplayerGame.Repo.Migrations.CreateGameEventsTable do
  use Ecto.Migration

  def change do
    create table(:game_events, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :event_type, :string

      add :player_id, references(:players, type: :uuid, on_delete: :nothing)
      add :game_instance_id, references(:game_instances, type: :uuid, on_delete: :nothing)
      add :game_state_id, references(:game_states, type: :uuid, on_delete: :nothing)

      timestamps()
    end
 end
end
