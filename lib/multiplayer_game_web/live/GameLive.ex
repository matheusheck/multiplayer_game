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

  def mount(_params, %{"id" => id, "unique_name" => unique_name}, socket) do
    player = MultiplayerGame.Player.create(id, unique_name)
    Game.maybe_add_player(player)

    socket =
      socket
      |> assign(:player, player)
      |> assign(:state, Game.state())
      |> assign(:unique_name, unique_name)

    Process.send_after(self(), :render_game, 1)
    {:ok, socket}
  end

  def handle_info(:render_game, %{assigns: %{player: %{id: id}} = _assigns} = socket) do
    state = Map.put(Game.state(), :current_player, id)

    Process.send_after(self(), :render_game, 1)
    {:noreply, push_event(socket, "game", state)}
  end

  def handle_event("key_down", payload, socket) do
    MultiplayerGame.Game.move_player(payload)

    {:noreply, socket}
  end
end
