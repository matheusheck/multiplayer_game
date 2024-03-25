function renderScreen(game, requestAnimationFrame, currentPlayerId) {
    const screen = document.getElementById('screen');
    const context = screen.getContext('2d');
    context.fillStyle = 'white';
    context.clearRect(0,  0, screen.width, screen.height);

    renderPlayers(game.players, context);
    renderFruits(game.fruits, context);
    renderCurrentPlayer(game.players[currentPlayerId], context);

    requestAnimationFrame(() => renderScreen(game, requestAnimationFrame, currentPlayerId));
}

function renderPlayers(players, context) {
    context.fillStyle = 'black';
    for (const playerId in players) {
        const [x, y] = players[playerId];
        context.fillRect(x, y,  1,  1);
    }
}

function renderFruits(fruits, context) {
    context.fillStyle = 'green';
    for (const fruitId in fruits) {
        const [x, y] = fruits[fruitId];
        context.fillRect(x, y,  1,  1);
    }
}

function renderCurrentPlayer(currentPlayer, context) {
    if (currentPlayer) {
        context.fillStyle = '#F0DB4F';
        context.fillRect(currentPlayer.x, currentPlayer.y,  1,  1);
    }
}
