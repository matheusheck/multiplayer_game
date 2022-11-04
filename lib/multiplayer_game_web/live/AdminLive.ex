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
    {:ok, new_state_pid} = MultiplayerGame.Game.start_game()
    {:noreply, assign(socket, :state_pid, new_state_pid)}
  end

  def handle_event("reset_state", _value, %{assigns: %{state_pid: state_pid}} = socket) do
    {:ok, new_state_pid} = MultiplayerGame.Game.reset_state(state_pid)
    {:noreply, assign(socket, :state_pid, new_state_pid)}
  end

  def handle_event("stop_game", _value, %{assigns: %{state_pid: state_pid}} = socket) do
    :ok = MultiplayerGame.Game.stop_game(state_pid)
    {:noreply, assign(socket, :state_pid, nil)}
  end
end
