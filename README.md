# SwiftChess

A Swift library that includes all the logic to make a chess game. This library is not an engine. It does not include any logic for any kind of chess theory or strategy.

# Installation

In Xcode, go to File > Swift Packages > Add Package Dependency... and paste the github URL

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

### Note that all moves with x and y start with 0. The upper right square of the board is (7, 7), not (8, 8). The lower left is (0, 0). Keep this in mind when dealing with moves. This is something that can be changed in the future.


**Make a move**

```swift
let game = Game()
// Create a move
let move = Move(from: (4, 1), to: (4, 3))
// Make move
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
// You can also get a result of the move
let result = game.makeMove(move: move) // .success | .error
```

**Check if a move can be played**
```swift
let move = Move(from: (5, 2), to: (5, 4))
game.canMove(move: move) // true | false
```
makeMove internally runs canMove so if you've already checked if you can move, you can force the move to avoid checking twice
```swift
game.makeMove(move: Move, forced: true)
```

**Pawn promotion**
```swift
game.willPromote(move: move) // true | false
// pass in a promotion parameter which will run if move does promote; defaults to queen
game.makeMove(move: move, .knight)
```
**Undo move**
```swift
game.undoMove()
```
## **Board methods and variables**
```swift
let board = Board()
board.isCheck() // true | false
board.legalMoves() // returns all legal moves as [Move]
board.moveForPiece(at: (x, y)) // returns all legal moves for piece
board.squaresAttacked() \\ returns array of squares that are attacked by the opposing pieces
board.canCastle // tuple containing booleans whether certain castling is legal ex. board.canCastle.whiteQueen true | false
board.ascii // returns board position as an ascii string
board.unicode // returns board positions as a unicode string
board.fen // returns board position as FEN string
```

#### Note: A lot of the Game functions that are implemented such as makeMove or willPromote are simply calling the funtion on the Board object. They may also be doing other logic though so it's best to call them on the Game object and not on the Board object.

```swift
// This is how the canMove function is implemented in the Game struct
mutating func canMove(move: Move) -> Bool {
        return board.canMove(move: move)
    }
```
