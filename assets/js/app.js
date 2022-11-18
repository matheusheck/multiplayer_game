
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import { keyboard_listener } from "./input"
import { renderScreen } from "./render"

let hooks = {};
let current_player_id = null

hooks.Listener = keyboard_listener(current_player_id)

window.addEventListener(
    "phx:game",
    game => {
        console.log("Game Received")
        current_player_id = game.detail.current_player
        renderScreen(game.detail, requestAnimationFrame, game.detail.current_player)
    }
)

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: hooks})
liveSocket.connect()


