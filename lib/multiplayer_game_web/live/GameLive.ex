defmodule MultiplayerGameWeb.GameLive do
  use MultiplayerGameWeb, :live_view

  alias MultiplayerGame.Game


  # def struct do game
  @type game :: %{
      players: Map.t(),
      fruits: Map.t(),
      screen: %{
          width: 10,
          height: 10
      }
  }

  def render(assigns) do
    ~H"""
    <section phx-hook="Listener" id="game" class="flex flex-col w-screen h-screen justify-center items-center text-center">
      <canvas class="game border-2 unblur" width="10" height="10" id="screen" phx-update="ignore"></canvas>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    player = MultiplayerGame.Player.create()
    Game.add_player(player)

    socket =
      socket
      |> assign(:player, player)
      |> assign(:state, Game.state())
    Process.send_after(self(), :render_game, 16)
    {:ok, socket}
  end


  def handle_info(:render_game, %{assigns: %{player: %{id: id}} = _assigns} = socket) do
    state = Map.put(Game.state, :current_player, id)

    Process.send_after(self(), :render_game, 16)
    {:noreply, push_event(socket, "game", state)}
  end

  def handle_event("key_down", payload, socket) do
    IO.inspect(payload, label: "........:::::: ......")

    {:noreply, socket}
  end
end
