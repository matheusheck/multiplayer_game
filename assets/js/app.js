// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"
// import "./game.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
// import topbar from "../vendor/topbar"

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

function renderScreen(game, requestAnimationFrame, currentPlayerId) {
    const screen = document.getElementById('screen')
    const context = screen.getContext('2d')
    context.fillStyle = 'white'
    context.clearRect(0, 0, 10, 10)

    for (const playerId in game.players) {
        const player = game.players[playerId]
        context.fillStyle = 'black'
        context.fillRect(player.x, player.y, 1, 1)
    }

    for (const fruitId in game.fruits) {
        const fruit = fruits[fruitId]
        context.fillStyle = 'green'
        context.fillRect(fruit.x, fruit.y, 1, 1)
    }

    const currentPlayer = game.players[currentPlayerId]

    if(currentPlayer) {
        context.fillStyle = '#F0DB4F'
        context.fillRect(currentPlayer.x, currentPlayer.y, 1, 1)
    }

    requestAnimationFrame(() => {
        renderScreen(game, requestAnimationFrame, currentPlayerId)
    })
}



let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: hooks})
liveSocket.connect()

// liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
// window.liveSocket = liveSocket

