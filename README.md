# SwiftChess

A Swift library that includes all the logic to make a chess game. This library is not an engine. It does not include any logic for any kind of chess theory or strategy.

# Usage

**Start a game**

```swift
// To create a new game, simply create a Game object
let game = Game()

// A Game object can also be created from a Board object
let board = Board()
let game = Game(board: board)

// Board objects can also be initialized with a FEN
let fen = FEN(fen: "3q4/1p1n1pk1/p1r1p1p1/2P1Pn1p/1P1N1P2/B5rP/5RPK/Q3R3 w - - 0 1")
let board = Board(fen: fen)
let game = Game(board: board)
```

**Make a move**

```swift
// Create a move
let game = Game()
let move = Move(from: (5, 2), to: (5, 4))
game.makeMove(move: move)
print(game.board.ascii)
/*
r n b q k b n r 
p p p p p p p p 
- - - - - - - - 
- - - - - - - - 
- - - - P - - - 
- - - - - - - - 
P P P P - P P P 
R N B Q K B N R
*/
