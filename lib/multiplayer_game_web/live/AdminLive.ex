defmodule MultiplayerGameWeb.AdminLive do
  use MultiplayerGameWeb, :live_view

  def render(assigns) do
    ~H"""
    <section phx-hook="Listener" id="game" class="flex flex-col w-screen h-screen justify-center items-center text-center">
      <h1>Admin</h1>
      <button phx-click="reset_state">Reset</button>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("reset_state", _value, socket) do

    {:noreply, assign(socket, :temperature, new_temp)}
  end
end
