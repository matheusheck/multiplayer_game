defmodule MultiplayerGame.Players do
  alias MultiplayerGame.Players.Player
  alias MultiplayerGame.Repo

  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end
end
