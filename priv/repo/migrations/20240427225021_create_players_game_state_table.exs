defmodule MultiplayerGame.Repo.Migrations.CreatePlayersGameStatesTable do
  use Ecto.Migration

  def change do
    create table(:players_game_states, primary_key: false) do
      add :player_id, references(:players, type: :uuid, on_delete: :nothing), primary_key: true
      add :game_state_id, references(:game_states, type: :uuid, on_delete: :delete_all), primary_key: true

      timestamps()
    end

    create unique_index(:players_game_states, [:player_id, :game_state_id])
 end
end
