defmodule MultiplayerGameWeb.AdminLive do
  use MultiplayerGameWeb, :live_view

  def render(assigns) do
    ~H"""
    <section phx-hook="Listener" id="game" class="flex flex-col w-screen h-screen justify-center items-center text-center">
      <h1>Admin</h1>
      <br />
      <p>Is game state initiated: <%= @is_game_state_initiated? %></p>
      <br />
      <button phx-click="start_game">Start Game</button>
      <p :if={@is_game_state_initiated?}>play at <a href="/" target="_blank"> AQUI </a></p>
      <button phx-click="reset_state">Reset</button>
      <button phx-click="stop_game">Stop game</button>
      <br />
      <br />
      <p>Adding fruits: <%= @keep_adding_fruits %></p>
      <br />
      <button phx-click="stat_fruits_add">start adding fruits</button>
      <button phx-click="stop_fruits_add">stop adding fruits</button>

    </section>
    """
  end

  def mount(_params, _session, socket) do
    MultiplayerGame.Game.State.subscribe()

    socket =
      socket
      |> assign(:keep_adding_fruits, false)
      |> assign(:is_game_state_initiated?, false)

    {:ok, assign(socket, :keep_adding_fruits, false)}
  end

  def handle_event("start_game", _value, socket) do
    MultiplayerGame.Game.State.start_game()
    {:noreply, assign(socket, :is_game_state_initiated?, true)}
  end

  def handle_event("reset_state", _value, socket) do
    MultiplayerGame.Game.State.reset_state()
    {:noreply, socket}
  end

  def handle_event("stat_fruits_add", _value, socket) do
    MultiplayerGame.Fruit.start_adding_fruit()
    {:noreply, assign(socket, :keep_adding_fruits, true)}
  end

  def handle_event("stop_fruits_add", _value, socket) do
    MultiplayerGame.Fruit.stop_adding_fruit()
    {:noreply, assign(socket, :keep_adding_fruits, false)}
  end

  def handle_event("stop_game", _value, socket) do
    :ok = MultiplayerGame.Game.State.stop_game()

    socket =
      socket
      |> assign(:state_pid, nil)
      |> assign(:is_game_state_initiated?, false)

    {:noreply, socket}
  end

  def handle_event("key_down", _payload, socket) do
    {:noreply, socket}
  end

  def handle_info({:new_state, %{is_adding_fruit?: is_adding_fruit?}}, socket) do
    {:noreply, assign(socket, :keep_adding_fruits, is_adding_fruit?)}
  end
end
