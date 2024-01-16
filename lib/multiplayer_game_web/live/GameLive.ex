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
      <svg  phx-click="ArrowUp" width="80px" height="80px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" transform="rotate(180)">
        <path d="M18.6 3H5.4A2.4 2.4 0 0 0 3 5.4v13.2A2.4 2.4 0 0 0 5.4 21h13.2a2.4 2.4 0 0 0 2.4-2.4V5.4A2.4 2.4 0 0 0 18.6 3Z" fill="#000000" fill-opacity=".16" stroke="#000000" stroke-width="1.5" stroke-miterlimit="10"/>
        <path d="m8 12 4 4 4-4" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M12 16V8" stroke="#000000" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round"/>
      </svg>
      <svg  phx-click="ArrowDown" width="80px" height="80px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M18.6 3H5.4A2.4 2.4 0 0 0 3 5.4v13.2A2.4 2.4 0 0 0 5.4 21h13.2a2.4 2.4 0 0 0 2.4-2.4V5.4A2.4 2.4 0 0 0 18.6 3Z" fill="#000000" fill-opacity=".16" stroke="#000000" stroke-width="1.5" stroke-miterlimit="10"/><path d="m8 12 4 4 4-4" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><path d="M12 16V8" stroke="#000000" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round"/></svg>
      <svg  phx-click="ArrowLeft" width="80px" height="80px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" transform="rotate(90)">
        <path d="M18.6 3H5.4A2.4 2.4 0 0 0 3 5.4v13.2A2.4 2.4 0 0 0 5.4 21h13.2a2.4 2.4 0 0 0 2.4-2.4V5.4A2.4 2.4 0 0 0 18.6 3Z" fill="#000000" fill-opacity=".16" stroke="#000000" stroke-width="1.5" stroke-miterlimit="10"/>
        <path d="m8 12 4 4 4-4" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M12 16V8" stroke="#000000" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round"/>
      </svg>
      <svg phx-click="ArrowRight" width="80px" height="80px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" transform="rotate(270)">
        <path d="M18.6 3H5.4A2.4 2.4 0 0 0 3 5.4v13.2A2.4 2.4 0 0 0 5.4 21h13.2a2.4 2.4 0 0 0 2.4-2.4V5.4A2.4 2.4 0 0 0 18.6 3Z" fill="#000000" fill-opacity=".16" stroke="#000000" stroke-width="1.5" stroke-miterlimit="10"/>
        <path d="m8 12 4 4 4-4" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M12 16V8" stroke="#000000" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round"/>
      </svg>
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

  def handle_event(click_arrow, _payload, %{assigns: %{player: %{id: player_id}}} = socket) do
    MultiplayerGame.Game.move_player(%{"keyPressed" => click_arrow, "playerId" => player_id})
    {:noreply, socket}
  end

  def handle_event("key_down", payload, socket) do
    MultiplayerGame.Game.move_player(payload)
    {:noreply, socket}
  end
end
