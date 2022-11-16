defmodule MultiplayerGameWeb.AdminLive do
  use MultiplayerGameWeb, :live_view

  def render(assigns) do
    ~H"""
    <section phx-hook="Listener" id="game" class="flex flex-col w-screen h-screen justify-center items-center text-center">
      <h1>Admin</h1>
      <button phx-click="start_game">Start Game</button>
      <button phx-click="reset_state">Reset</button>
      <button phx-click="stop_game">Stop game</button>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("start_game", _value, socket) do
    MultiplayerGame.Game.start_game()
    {:noreply, socket}
  end

  def handle_event("reset_state", _value, socket) do
    MultiplayerGame.Game.reset_state()
    {:noreply, socket}
  end

  def handle_event("stop_game", _value, socket) do
    :ok = MultiplayerGame.Game.stop_game()
    {:noreply, assign(socket, :state_pid, nil)}
  end

  def handle_event("key_down", _payload, socket) do

    {:noreply, socket}
  end
end
