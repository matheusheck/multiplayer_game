defmodule MultiplayerGameWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence, otp_app: :multiplayer_game,
                        pubsub_server: MultiplayerGame.PubSub
end
