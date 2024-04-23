
import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"

let hooks = {
    CopyToClipboard: {
       mounted() {
         this.handleEvent("copy_to_clipboard", ({text}) => {
            console.log("chegou")
           window.copyToClipboard(text);
         });
       }
    }
   };

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: hooks})
liveSocket.connect()


window.copyToClipboard = function(text) {
    navigator.clipboard.writeText(text).then(function() {
       console.log('Copying to clipboard was successful!');
    }, function(err) {
       console.error('Could not copy text: ', err);
    });
   };

   