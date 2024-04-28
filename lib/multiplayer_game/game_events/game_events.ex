defmodule MultiplayerGame.GameEvents do
  alias MultiplayerGame.GameEvents.GameEvent
  alias MultiplayerGame.Repo

  def create_game_event(attrs \\ %{}) do
    %GameEvent{}
    |> GameEvent.changeset(attrs)
    |> Repo.insert()
  end
end
