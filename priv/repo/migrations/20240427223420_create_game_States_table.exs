
defmodule MultiplayerGame.Repo.Migrations.CreateGameStatesTable do
  use Ecto.Migration

  def change do
    create table(:game_states, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :game_instance_id, references(:game_instances, type: :uuid, on_delete: :nothing)
    end
  end
end
