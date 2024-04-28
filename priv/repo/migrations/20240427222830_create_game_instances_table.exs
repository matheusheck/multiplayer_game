defmodule MultiplayerGame.Repo.Migrations.CreateGameInstancesTable do
  use Ecto.Migration

  def change do
    create table(:game_instances, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      timestamps()
    end
 end
end
