defmodule MultiplayerGame.GameInstances do
  alias MultiplayerGame.GameInstances.GameInstance
  alias MultiplayerGame.Repo

  def create_game_instance(attrs \\ %{}) do
    %GameInstance{}
    |> GameInstance.changeset(attrs)
    |> Repo.insert()
  end
end
