defmodule MultiplayerGameWeb.GameLive do
  use MultiplayerGameWeb, :live_view

  alias MultiplayerGame.Game
  alias MultiplayerGame.Game.State

  @base_classes "flex items-center justify-center text-4xl w-10 h-10 rounded"

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center h-screen justify-center p-4 lg:p-6 bg-slate-600">
      <div class="flex flex-col w-100 items-center p-4 justify-center rounded-lg bg-slate-400">
        <h1 class=" w-full text-center text-xl font-extrabold">
          Welcome, <%= @unique_name %> 🐰!
        </h1>
        <p class="my-4 w-full text-center text-lg">
          Share this link to play with a friend
        </p>
        <button id="copy-button" phx-click="copy_link" phx-hook="CopyToClipboard" class="bg-slate-800 hover:bg-blue-700 mb-4 text-white py-2 px-4 rounded">
          Copy Link
        </button>
        <%= render_game_canvas(%{canvas: @canvas, current_player: @current_player, state: @state}) %>
        <h1 class="flex f-row w-full justify-center text-xl font-extrabold py-4">
          Score
        </h1>
        <div class="flex flex-col w-full max-h-20 rounded-md bg-slate-200 p-4 rounded gap-1 overflow-auto">
          <%= for {_id, player} <- @state.players do %>
          <div class="flex flex-row w-full place-content-between p-2 rounded bg-slate-100">
            <h3> <%= player.name %></h3>
            <h2><%= if @state != nil, do: Map.get(@state.players[player.id], :points) %></h2>
            </div>
          <% end %>
        </div>
      </div>
      <p class="my-4 w-full text-center text-lg">
        This is a multiplayer game written in Elixir.
        <a href="https://github.com/matheusheck/multiplayer_game">Check more on GitHub.
        </a>
      </p>
    </div>
    """
  end

  def render_game_canvas(assigns) do
    ~H"""
    <div phx-window-keydown="key_down" class="flex flex-col items-center justify-center rounded-md">
       <div class="grid grid-cols-8 border-2 rounded-md bg-slate-200 p-3 gap-1">
         <%= for y <- 0..7, x <- 0..7 do %>
           <div class={get_classes({x,y})}>
             <%= render_cell(@canvas, @current_player, {x,y}) %>
           </div>
         <% end %>
       </div>
       <%= render_mobile_gamepad(%{current_player: @current_player}) %>
    </div>
    """
  end

  def render_mobile_gamepad(assigns) do
    ~H"""
    <div class="flex items-center justify-center p-4 lg:hidden">
       <div class="grid grid-cols-3">
         <%= for y <- 0..2, x <- 0..2 do %>
           <div class="flex items-center justify-center text-4xl w-12 h-12" phx-click={get_click_payload({x,y})}>
              <%= render_gamepad_arrow({x,y}) %>
           </div>
         <% end %>
       </div>
    </div>
    """
  end

  def mount(_params, %{"unique_name" => unique_name, "id" => id}, socket) do
    with {:ok, _} <- MultiplayerGame.Game.State.maybe_start_game() do
      if connected?(socket) do
        MultiplayerGame.Game.maybe_add_player(
          id,
          unique_name
        )
      end

      state = State.get()

      socket =
        socket
        |> assign(:current_player, id)
        |> assign(:unique_name, unique_name)
        |> assign(:canvas, map_state_to_canvas(state))
        |> assign(:state, state)

      IO.inspect(state, label: "state")

      if MultiplayerGame.Game.count_players() == 2, do: MultiplayerGame.Fruit.start_adding_fruit()
      State.subscribe()
      State.notify_new_state()
      MultiplayerGame.Monitor.monitor(self(), __MODULE__, %{current_player: id})
      {:ok, socket}
    end
  end

  def unmount(%{current_player: id}, _reason) do
    if MultiplayerGame.Game.count_players() == 1, do: MultiplayerGame.Fruit.stop_adding_fruit()
    Game.remove_player(id)
    :ok
  end

  def handle_info({:new_state, state}, socket) do
    socket =
      socket
      |> assign(:canvas, map_state_to_canvas(state))
      |> assign(:state, state)

    {:noreply, socket}
  end

  def handle_event("key_down", payload, %{assigns: %{current_player: current_player}} = socket) do
    MultiplayerGame.Game.move_player(payload, current_player)
    {:noreply, socket}
  end

  def handle_event("copy_link", _value, socket) do
    link_to_copy = "https://multiplayer-game.fly.dev/"
    {:noreply, push_event(socket, "copy_to_clipboard", %{text: link_to_copy})}
  end

  def handle_event(click_arrow, _payload, %{assigns: %{current_player: current_player}} = socket) do
    IO.inspect("CLICOU!!")
    MultiplayerGame.Game.move_player(%{"key" => click_arrow}, current_player)
    {:noreply, socket}
  end

  defp map_state_to_canvas(state) do
    state
    |> map_players
    |> add_fruits_to_mapped_canvas(state.fruits)
  end

  defp map_players(state) do
    Enum.reduce(state.players, %{}, fn {_player_id, player}, acc ->
      Map.put(acc, {player.x, player.y}, %{type: :player, id: player.id})
    end)
  end

  defp add_fruits_to_mapped_canvas(canvas, fruits) do
    Enum.reduce(fruits, canvas, fn {_id, fruit}, acc ->
      Map.put(acc, {fruit.x, fruit.y}, %{type: :fruit, id: fruit.id})
    end)
  end

  defp get_classes({x, y}) when rem(x + y, 2) == 0,
    do: "#{@base_classes} bg-blue-100"

  defp get_classes(_position), do: "#{@base_classes} bg-slate-100"

  defp render_cell(canvas, current_player_id, position) do
    canvas[position]
    |> render_cell(current_player_id)
  end

  defp render_cell(nil, _current_player_id), do: ""

  defp render_cell(%{type: type, id: id}, current_player_id) do
    case type do
      :player -> get_player_icon(id, current_player_id)
      :fruit -> "🍉"
    end
  end

  defp render_gamepad_arrow(nil), do: ""

  defp render_gamepad_arrow({0, 1}), do: "⬅️"
  defp render_gamepad_arrow({1, 0}), do: "⬆️"
  defp render_gamepad_arrow({1, 2}), do: "⬇️"
  defp render_gamepad_arrow({2, 1}), do: "➡️"
  defp render_gamepad_arrow(_position), do: ""

  defp get_click_payload({0, 1}), do: "ArrowLeft"
  defp get_click_payload({1, 0}), do: "ArrowUp"
  defp get_click_payload({1, 2}), do: "ArrowDown"
  defp get_click_payload({2, 1}), do: "ArrowRight"
  defp get_click_payload(_position), do: ""

  defp get_player_icon(id, current_player_id) when id == current_player_id, do: "🐰"
  defp get_player_icon(_id, _current_player_id), do: "🐜"
end
