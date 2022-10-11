defmodule MultiplayerGameWeb.Plug.AssignName do
  def init(opts), do: opts

  def call(conn = %{session: %{id: _}}, _opts) do
    conn |> IO.inspect(label: "...............AQUIIIIIII......")
  end

  def call(conn, _opts) do
    conn =
      conn
      |> Plug.Conn.put_session(:unique_name, MultiplayerGame.Names.generate())
      |> Plug.Conn.put_session(:id, UUID.uuid4())
    conn
  end
end
