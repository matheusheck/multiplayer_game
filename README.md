![example workflow](https://github.com/matheusheck/multiplayer_game/actions/workflows/elixir.yml/badge.svg)
# My multiplayer Game

![screenshot of this game](https://github.com/matheusheck/multiplayer_game/assets/39709032/80540279-b737-48e6-98fe-41f4b08aaec1)

## What is it?

A multiplayer game using LiveView and Tailwind written in Elixir with Phoenix to connect mutiple players at same game.

It is a repository started to think of separations of concerns in modern functional programming.
It was also a Hook investigation. This version got rid of `<canvas>` tag to use modern Liveview.

## How to play

This game is a simple game where you are a rat 🐭 running for your food!
Get it before your opponets, the ants 🐜.

## How to run it locally

This app uses `.tools-version` and recommend using ASDF to install. Check guide bellow.

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Install ESBuild `mix esbuild.install`
- Generate assets `mix assets.deploy`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- ASDF <> Elixir: https://thinkingelixir.com/install-elixir-using-asdf/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
