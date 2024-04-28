defmodule MultiplayerGame.Repo.Migrations.CreateFruitsPositionsGameStatesTable do
    use Ecto.Migration

    def change do
      create table(:state_fruits_positions, primary_key: false) do
        add :game_state_id, references(:game_states, type: :uuid, on_delete: :nothing)
        add :position_x, :integer
        add :position_y, :integer
      end
    end
  end
