
import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
// import { listener } from "./input"
import { renderScreen } from "./render"

let hooks = {};
let current_player_id = null

hooks.Listener = {
    mounted() {
        window.addEventListener('keydown', e => this.handleKeydown(e))
    },

    handleKeydown(event) {
        console.log(event)
        const keyPressed = event.key
    
        const command = {
            type: 'move-player',
            playerId: current_player_id,
            keyPressed
        }
    
        this.pushEvent("key_down", command)
    }
  };
  

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


