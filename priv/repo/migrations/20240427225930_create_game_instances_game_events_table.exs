defmodule MultiplayerGame.Repo.Migrations.CreateGameInstancesGameEventsTable do
  use Ecto.Migration

  def change do
    create table(:game_instances_game_events, primary_key: false) do
      add :game_instance_id, references(:game_instances, type: :uuid, on_delete: :delete_all), primary_key: true
      add :game_event_id, references(:game_events, type: :uuid, on_delete: :delete_all), primary_key: true

      timestamps()
    end

    create unique_index(:game_instances_game_events, [:game_instance_id, :game_event_id])

  end
end
