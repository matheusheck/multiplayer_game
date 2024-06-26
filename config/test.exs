import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :multiplayer_game, MultiplayerGameWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "OA+ruM8/x24BR6V+3pcdomGPPi+eM5JUKLFaeyJNu4dORVHmIV2R0IGKXW7JhE3M",
  server: false,
  session_options: [
    store: :cookie,
    key: "_multiplayer_game_key",
    signing_salt: "w4dxsV5v"
  ]

config :multiplayer_game, MultiplayerGame.Repo,
  database: "multiplayer_game_test",
  username: "postgres",
  password: "pass123",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
