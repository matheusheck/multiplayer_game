defmodule MultiplayerGame.Repo.Migrations.CreatePlayerPositionsGameStatesTable do
  use Ecto.Migration

  def change do
    create table(:state_player_positions, primary_key: false) do
      add :game_state_id, references(:game_states, type: :uuid, on_delete: :nothing)
      add :player_id, references(:players, type: :uuid, on_delete: :nothing)
      add :position_x, :integer
      add :position_y, :integer
    end

  create unique_index(:state_player_positions, [:player_id, :game_state_id])

  end
end
