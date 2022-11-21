const listener = {
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
  
  export {listener};