# README

Creating a game:
- A client may create a new game by sending a post request to chessEngineIP/games/new
- If a game is successfully created, the response will hold a json object with the following structure:

{"token":"hMnkKfqhbJFWOqFMJtcEZEncgszsnxFYNxtvnzJpXqNfprcnMS",
 "id":6,
 "turn":true,
 "board":
  [["r","n","b","k","q","b","n","r"],["p","p","p","p","p","p","p","p"],["","","","","","","",""],["","","","","","","",""],["","","","","","","",""],["","","","","","","",""],["P","P","P","P","P","P","P","P"],["R","N","B","K","Q","B","N","R"]]
}

"token" is the unique player token corresponding to the client. This is how the engine distinguishes between players.
"id" is the game id
"turn" is true when it is the requesting client's turn
"board" is the current state of the board represented by an 2d array holding an 8x8 grid. Capital letters are white and lowercase are black.
- the player that creates the game will be white


Joining a game:
- To join an existing game that only has 1 player, a client may send a post request to chessEngineIP/games/:id/join
- This will return the same json object as above, but without "id" 
- The player that joins will be black

Gameplay:
- The two clients will poll the engine with get requests to chessEngineIP/games/:id/state to get the state of the game and check whose turn it is. This request will return the following json object:

{"turn":true,"board":[["r","n","b","k","q","b","n","r"],["p","p","p","p","p","p","p","p"],["","","","","","","",""],["","","","","","","",""],["","","","","","","",""],["","","","","","","",""],["P","P","P","P","P","P","P","P"],["R","N","B","K","Q","B","N","R"]], "en_passant": {"x": -1, "y": -1}

"turn" this time signifies whether or not it is white's turn
"en_passant", if not equal to [-1, -1] tells the client that an en passant capture is available at that specific square

- When, from the polling requests, the client determines the turn is his, the client calculates his next move and sends
a post request to /games/:id/move { "token" : ... "from" : [x,y] "to" : [x,y] }
- Here, the token must correspond to the token of the player whose turn it is. 
- from and to are the coordinates on the 8x8 chess board from which and to where the client wishes to move
- If the move is invalid, the response will contain a json object with an "error" key 
