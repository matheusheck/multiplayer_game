defmodule MultiplayerGame.GameStates do
  alias MultiplayerGame.GameStates.GameState
  alias MultiplayerGame.Repo

  def create_game_state(attrs \\ %{}) do
    %GameState{}
    |> GameState.changeset(attrs)
    |> Repo.insert()
  end
end
