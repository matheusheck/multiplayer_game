defmodule MultiplayerGameWeb.PageController do
  use MultiplayerGameWeb, :controller

  @salt "user socket"

  def index(conn, _params) do
    render(conn, "index.html",
      user_token:
        Phoenix.Token.sign(MultiplayerGameWeb.Endpoint, @salt, MultiplayerGame.Names.generate())
    )
  end
end
