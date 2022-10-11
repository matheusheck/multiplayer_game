defmodule MultiplayerGameWeb.Router do
  use MultiplayerGameWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MultiplayerGameWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MultiplayerGameWeb.Plug.AssignName
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MultiplayerGameWeb do
    pipe_through :browser

    # get "/", PageController, :index

    live "/", GameLive
    live "/admin", AdminLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", MultiplayerGameWeb do
  #   pipe_through :api
  # end
end
