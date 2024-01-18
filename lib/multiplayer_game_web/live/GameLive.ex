defmodule MultiplayerGameWeb.GameLive do
  use MultiplayerGameWeb, :live_view

  alias MultiplayerGame.Game
  alias MultiplayerGame.Game.State

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
      <div class="justify-center items-center text-center">
        <h1>Hi, <%= @unique_name %></h1>
        <h1>You scored <%= if @state.players[@player.id] != nil, do: Map.get(@state.players[@player.id], :points) %></h1>
      </div>
      <section phx-hook="Listener" id="game" class="flex flex-col w-screen justify-center items-center text-center">
        <canvas class="game border-2 unblur" width="10" height="10" id="screen" phx-update="ignore"></canvas>
      </section>
      <div class="justify-center items-center text-center">
        <h1>Scores </h1>
        <%= for {_id, player} <- @state.players do %>
          <p><%= player.name %> scored <%= if @state != nil, do: Map.get(@state.players[player.id], :points) %></p>
        <% end %>
      </div>
      <div class="justify-center items-center">
        <div class="grid grid-cols-3 grid-rows-3 gap-2 p-4 max-w-sm  mx-auto">
          <div
            phx-click="ArrowUp"
            class="col-start-2 row-start-1 width-20 focus:outline-none bg-gray-200 w-10 border-none p-1 transition-transform transform hover:scale-105"
            id="ArrowUp"
          >
            <svg width="30" height="20" viewBox="0 0 10 10">
              <g transform="rotate(0, 5, 5)">
                <path d="M5,4 L7,6 L3,6 L5,4" />
              </g>
            </svg>
          </div>
          <button
            phx-click="ArrowLeft"
            class="col-start-1 row-start-2 focus:outline-none bg-gray-200 w-10 border-none p-1 transition-transform transform hover:scale-105"
            id="ArrowLeft"
          >
            <svg width="30" height="20" viewBox="0 0 10 10">
              <g transform="rotate(-90, 5, 5)">
                <path d="M5,4 L7,6 L3,6 L5,4" />
              </g>
            </svg>
          </button>
          <button
            phx-click="ArrowDown"
            class="col-start-2 row-start-3 focus:outline-none bg-gray-200 w-10 border-none p-1 transition-transform transform hover:scale-105"
            id="ArrowDown"
          >
            <svg width="30" height="20" viewBox="0 0 10 10">
              <g transform="rotate(180, 5, 5)">
                <path d="M5,4 L7,6 L3,6 L5,4" />
              </g>
            </svg>
          </button>
          <button
            phx-click="ArrowRight"
            class="col-start-3 row-start-2 focus:outline-none bg-gray-200 w-10 border-none p-1 transition-transform transform hover:scale-105"
            id="ArrowRight"
          >
            <svg width="30" height="20" viewBox="0 0 10 10">
              <g transform="rotate(90, 5, 5)">
                <path d="M5,4 L7,6 L3,6 L5,4" />
              </g>
            </svg>
          </button>
        </div>
      </div>
    """
  end

  def mount(_params, %{"player" => player, "unique_name" => unique_name}, socket) do
    socket =
      socket
      |> assign(:player, player)
      |> assign(:unique_name, unique_name)
      |> assign(:state, State.get())

    if MultiplayerGame.Game.count_players() == 2, do: MultiplayerGame.Fruit.start_adding_fruit()
    State.subscribe()
    State.notify_new_state()
    {:ok, socket}
  end

  def terminate(_reason, %{assigns: %{player: %{id: player_id}}}) do
    if MultiplayerGame.Game.count_players() == 1, do: MultiplayerGame.Fruit.stop_adding_fruit()
    Game.remove_player(player_id)
  end

  def handle_info({:new_state, state}, %{assigns: %{player: %{id: id}}} = socket) do
    state_to_render = Map.put(state, :current_player, id)

    socket =
      socket
      |> push_event("game", state_to_render)
      |> assign(:state, state_to_render)

    {:noreply, socket}
  end

  def handle_event("key_down", payload, socket) do
    MultiplayerGame.Game.move_player(payload)
    {:noreply, socket}
  end

  def handle_event(click_arrow, _payload, %{assigns: %{player: %{id: player_id}}} = socket) do
    MultiplayerGame.Game.move_player(%{"keyPressed" => click_arrow, "playerId" => player_id})
    {:noreply, socket}
  end

end
