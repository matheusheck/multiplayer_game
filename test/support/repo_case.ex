defmodule MultiplayerGame.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias MultiplayerGame.Repo

      import Ecto
      import Ecto.Query
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MultiplayerGame.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(MultiplayerGame.Repo, {:shared, self()})
    end

    :ok
  end
end
