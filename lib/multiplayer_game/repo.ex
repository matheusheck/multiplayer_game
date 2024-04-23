defmodule MultiplayerGame.Repo do
  use Ecto.Repo,
    otp_app: :multiplayer_game,
    adapter: Ecto.Adapters.Postgres
end
