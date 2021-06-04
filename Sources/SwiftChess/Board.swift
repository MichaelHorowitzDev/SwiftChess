//
//  Board.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/6/21.
//

import Foundation


public struct Board {
    var board: [[Piece?]]
    var turn: PieceColor = .white
    var moves = [(move: Move, pieceMoved: Piece, pieceCaptured: Piece?)]()
    var fenMoves = [String]()
    var canCastle = (whiteKing: true, whiteQueen: true, blackKing: true, blackQueen: true)
    var halfmoveClock = 0
    var fullmoveNumber = 1
    var enPassantSquare: (x: Int, y: Int)?
    
    // create board with starting board setup
    public init() {
        self.board = [
            [Rook(color: .white), Knight(color: .white), Bishop(color: .white), Queen(color: .white), King(color: .white), Bishop(color: .white), Knight(color: .white), Rook(color: .white)],
            [Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white), Pawn(color: .white)],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black), Pawn(color: .black)],
            [Rook(color: .black), Knight(color: .black), Bishop(color: .black), Queen(color: .black), King(color: .black), Bishop(color: .black), Knight(color: .black), Rook(color: .black)]
        ]
        self.fenMoves = [self.fen]
    }
    // create board with individual parameters; only intended to be used for initializing board with Fen struct
    init(board: [[Piece?]], turn: PieceColor, canCastle: (Bool, Bool, Bool, Bool), halfmoveClock: Int, fullmoveNumber: Int, enPassantSquare: (x: Int, y: Int)?) {
        self.board = board
        self.turn = turn
        self.canCastle = canCastle
        self.halfmoveClock = halfmoveClock
        self.fullmoveNumber = fullmoveNumber
        self.enPassantSquare = enPassantSquare
        self.fenMoves = [self.fen]
    }
    // init board with FEN
    public init(fen: FEN) {
        if fen.isValid == false {
            fatalError("Invalid FEN Recieved")
        } else {
            self = fen.board
            self.fenMoves = [self.fen]
        }
    }
    // get board as unicode string
    public var unicode: String {
        var string = ""
        for i in board.reversed() {
            for piece in i {
                if piece?.color == .white {
                    switch piece {
                    case is King:
                        string.append("♔")
                    case is Queen:
                        string.append("♕")
                    case is Rook:
                        string.append("♖")
                    case is Bishop:
                        string.append("♗")
                    case is Knight:
                        string.append("♘")
                    case is Pawn:
                        string.append("♙")
                    default:
                        string.append("-")
                    }
                } else if piece?.color == .black {
                    switch piece {
                    case is King:
                        string.append("♚")
                    case is Queen:
                        string.append("♛")
                    case is Rook:
                        string.append("♜")
                    case is Bishop:
                        string.append("♝")
                    case is Knight:
                        string.append("♞")
                    case is Pawn:
                        string.append("♟︎")
                    default:
                        string.append("-")
                    }
                } else {
                    string.append("-")
                }
            }
            string.append("\n")
        }
        return string
    }
    // get board as ascii string
    public var ascii: String {
        var string = ""
        for i in board.reversed() {
            for piece in i {
                var square = ""
                switch piece {
                case is Pawn:
                    square = "p "
                case is Rook:
                    square = "r "
                case is Knight:
                    square = "n "
                case is Bishop:
                    square = "b "
                case is Queen:
                    square = "q "
                case is King:
                    square = "k "
                default:
                    square = "- "
            }
                if piece?.color == .white {
                    square = square.uppercased()
                }
                string.append(square)
            }
            string.append("\n")
                
        }
        return string
    }
    public func squaresAttacked() -> [(Int, Int)] {
        var attackedSquares = [(Int, Int)]()
        for rank in 0...board.count-1 {
            for item in 0...board[rank].count-1 {
                if board[rank][item]?.color == turn.opposite {
                    attackedSquares.append(contentsOf: board[rank][item]!.attackingSquares(x: item, y: rank, board: board))
                }
            }
        }
        return attackedSquares
    }
    // is the king in check; toggles turn and checks if the king can be captured;
//    TODO improve check detection in the future; current implementation is very inefficient
    public mutating func isCheck() -> Bool {
        // toggle turn to see if opponent can capture our king
        turn.toggle()
        for rank in 0...board.count-1 {
            for item in 0...board[rank].count-1 {
                if board[rank][item] is King && board[rank][item]?.color == turn {
                    //get king position and check if it is attacked
                    if squaresAttacked().contains(where: {$0 == (item, rank)}) {
                        turn.toggle()
                        return true
                    }
                }
            }
        }
        turn.toggle()
        return false
    }
    // get the current gamestate
    mutating func gameState() -> GameState {
        if halfmoveClock == 50 {
            return .moveRule
        }
        var count = [String:Int]()
        // remove half moves and full moves from fen
        let fenMoves = fenMoves.map {
            return $0.removingUpTo(" ").removingUpTo(" ")
        }
        // count number of times a position appears
        for move in fenMoves {
            count[move] = (count[move] ?? 0) + 1
        }
        // if same position appears 3 times
        if count.values.contains(where: {$0 >= 3}) {
            return .repetition
        }
        for rank in 0...board.count-1 {
            for item in 0...board[rank].count-1 {
                // locate king
                if board[rank][item] is King && board[rank][item]?.color == turn {
                    // check if there are zero legal moves
                    if generateLegalMoves(kingPosition: (item, rank), moves: generateAllMoves()).count == 0 {
                        turn.toggle()
                        // if in check and no moves = checkmate
                        if isCheck() {
                            turn.toggle()
                            return .checkmate
                        } else {
                            // if not in check = stalemate
                            turn.toggle()
                            return .stalemate
                        }
                    } else {
                        // if legal moves > 0 = in check
                        turn.toggle()
                        if isCheck() {
                            turn.toggle()
                            return .check
                        }
                        turn.toggle()
                    }
                }
            }
        }
        return .playing
    }
    mutating func generateLegalMoves(kingPosition: (x: Int, y: Int), moves: [Move]) -> [Move] {
        var moves = moves
        // check if move makes king capturable
        for (i, move) in moves.enumerated().reversed() {
            // test each move and if king is in check
            testMove(move: move)
            if isCheck() {
                moves.remove(at: i)
                testUndoMove()
                continue
            }
            testUndoMove()
            // check if castling is legal
            if board[move.from.y][move.from.x] is King {
                // can castle kingside
                if move.to.x-move.from.x == 2 {
                    testMove(move: Move(from: move.from, to: (move.from.x+1, move.from.y)))
                    if isCheck() {
                        moves.remove(at: i)
                        testUndoMove()
                        continue
                    }
                    testUndoMove()
                    testMove(move: Move(from: move.from, to: (move.from.x+2, move.from.y)))
                    if isCheck() {
                        moves.remove(at: i)
                        testUndoMove()
                        continue
                    }
                    testUndoMove()
                }
                // can castle queenside
                if move.to.x-move.from.x == -2 {
                    testMove(move: Move(from: move.from, to: (move.from.x-1, move.from.y)))
                    if isCheck() {
                        moves.remove(at: i)
                        testUndoMove()
                        continue
                    }
                    testUndoMove()
                    testMove(move: Move(from: move.from, to: (move.from.x-2, move.from.y)))
                    if isCheck() {
                        moves.remove(at: i)
                        testUndoMove()
                        continue
                    }
                    testUndoMove()
                }
            }
            if board[move.from.y][move.from.x] is Pawn {
                // check if square to move to is emtpy
                if board[move.to.y][move.to.x] == nil {
                    // if pawn is moving diagonally
                    if move.to.x != move.from.x {
                        // if en passant square is empty then en passant is illegal
                        if enPassantSquare == nil {
                            moves.remove(at: i)
                            continue
                        } else {
                            // if square isn't en passant square then move is illegal
                            if move.to != enPassantSquare! {
                                moves.remove(at: i)
                                continue
                            }
                        }
                    }
                }
            }
        }
        return moves
    }
    func generateAllMoves() -> [Move] {
        var moves = [Move]()
        // iterate through each piece on the board of the turn color and get all of its legal moves
        for rank in 0...board.count-1 {
            for item in 0...board[rank].count-1 {
                if let piece = board[rank][item] {
                    if piece.color == turn {
                        moves.append(contentsOf: piece.moves(x: item, y: rank, board: board))
                    }
                }
            }
        }
        // get castling moves
        if turn == .white {
            if canCastle.whiteKing {
                if board[0][5] == nil && board[0][6] == nil {
                    moves.append(Move(from: (4, 0), to: (6, 0)))
                }
            }
            if canCastle.whiteQueen {
                if board[0][3] == nil && board[0][2] == nil {
                    moves.append(Move(from: (4, 0), to: (2, 0)))
                }
            }
        } else {
            if canCastle.blackKing {
                if board[7][5] == nil && board[0][6] == nil {
                    moves.append(Move(from: (4, 7), to: (6, 7)))
                }
            }
            if canCastle.blackQueen {
                if board[0][3] == nil && board[0][2] == nil {
                    moves.append(Move(from: (4, 7), to: (2, 7)))
                }
            }
        }
        return moves
    }
    // check if move will result in promotion
    func willPromote(move: Move) -> Bool {
        // if piece is pawn and square moves to last rank
        if board[move.from.y][move.from.x] is Pawn {
            if turn == .white {
                if move.to.y == 7 {
                    return true
                }
            } else {
                if move.to.y == 0 {
                    return true
                }
            }
        }
        return false
    }
    // generates all legal moves
    public mutating func legalMoves() -> [Move] {
        for rank in 0...board.count-1 {
            for item in 0...board[rank].count-1 {
                if board[rank][item] is King && board[rank][item]?.color == turn {
                    return generateLegalMoves(kingPosition: (item, rank), moves: generateAllMoves())
                }
            }
        }
        return []
    }
    public mutating func moveForPiece(at point: (x: Int, y: Int)) -> [Move] {
        var moves = [Move]()
        if point.y < board.count {
            if point.x < board[point.y].count {
                // check if piece is of same color; also makes sure piece isn't nil
                if board[point.y][point.x]?.color == turn {
                    moves = board[point.y][point.x]!.moves(x: point.x, y: point.y, board: board)
                    // get moves for king; castling moves
                    if board[point.y][point.x] is King {
                        if turn == .white {
                            if canCastle.whiteKing {
                                if board[0][5] == nil && board[0][6] == nil {
                                    moves.append(Move(from: (4, 0), to: (6, 0)))
                                }
                            }
                            if canCastle.whiteQueen {
                                if board[0][3] == nil && board[0][2] == nil {
                                    moves.append(Move(from: (4, 0), to: (2, 0)))
                                }
                            }
                        } else {
                            if canCastle.blackKing {
                                if board[7][5] == nil && board[0][6] == nil {
                                    moves.append(Move(from: (4, 7), to: (6, 7)))
                                }
                            }
                            if canCastle.blackQueen {
                                if board[0][3] == nil && board[0][2] == nil {
                                    moves.append(Move(from: (4, 7), to: (2, 7)))
                                }
                            }
                        }
                    }
                    // get legal moves for generated pseudolegal moves
                    for rank in 0...board.count-1 {
                        for item in 0...board[rank].count-1 {
                            if board[rank][item] is King && board[rank][item]?.color == turn {
                                moves = generateLegalMoves(kingPosition: (item, rank), moves: moves)
                            }
                        }
                    }
                }
            }
        }
        return moves
    }
    mutating func canMove(move: Move) -> Bool {
        // first generate all pseudolegal moves
        var moves = generateAllMoves()
        // iterate through board to find king location and generate legal moves
        for rank in 0...board.count-1 {
            for item in 0...board[rank].count-1 {
                if board[rank][item] is King && board[rank][item]?.color == turn {
                    moves = generateLegalMoves(kingPosition: (item, rank), moves: moves)
                }
            }
        }
        // if legal moves contains move then move is legal
        for i in moves {
            if i == move {
                return true
            }
        }
        return false
    }
    mutating func undoMove() {
        // first fen is starting position so fen must be greater than 1
        // remove last fen and get array of fen moves
        // set current board to last fen position
        // set fen moves of that board to the current fen moves - last fen
        if fenMoves.count > 1 {
            fenMoves.removeLast()
            let fenMoves = fenMoves
            self = FEN(fen: fenMoves.last!).board
            self.fenMoves = fenMoves
        }
    }
    // returns fen of current board
    public var fen: String {
        return FEN(board: self).fen
    }
    // used for testing an undo move when checking for legality of moves
    // used to prevent potential issues with removing board state that may have occured in game
    mutating func testUndoMove() {
        if moves.count > 0 {
            let move = Move(from: moves.last!.move.to, to: moves.last!.move.from)
            board[move.to.1][move.to.0] = board[move.from.y][move.from.x]
            board[move.from.y][move.from.x] = moves.last!.pieceCaptured
            moves.removeLast()
            turn.toggle()
        }
    }
    // used for testing a move when checking for legality of moves
    // used to prevent potential issues with appending board state that hasn't actually occured in game
    mutating func testMove(move: Move) {
        moves.append((move: move, pieceMoved: board[move.from.y][move.from.x]!, pieceCaptured: board[move.to.1][move.to.0]))
        board[move.to.1][move.to.0] = board[move.from.y][move.from.x]
        board[move.from.y][move.from.x] = nil
        turn.toggle()
    }
    @discardableResult
    mutating func makeMove(move: Move, forced: Bool = false, _ promotion: Promotion = .queen) -> MoveResult {
        if forced || canMove(move: move) {
            halfmoveClock+=1
            if turn == .black {
                fullmoveNumber += 1
            }
            if enPassantSquare != nil {
                // en passant
                if board[move.from.y][move.from.x] is Pawn && move.to == enPassantSquare! {
                    halfmoveClock = 0
                    if turn == .white {
                        board[enPassantSquare!.y-1][enPassantSquare!.x] = nil
                    } else {
                        board[enPassantSquare!.y+1][enPassantSquare!.x] = nil
                    }
                    board[move.to.y][move.to.x] = board[move.from.y][move.from.x]
                    board[move.from.y][move.from.x] = nil
                    turn.toggle()
                    fenMoves.append(self.fen)
                    return .success
                }
            }
            // reset halfmove if capture
            if board[move.to.y][move.to.x] != nil {
                halfmoveClock = 0
            }
            // handle castling
            if board[move.from.y][move.from.x] is King {
                if turn == .white {
                    canCastle.whiteKing = false
                    canCastle.whiteQueen = false
                } else {
                    canCastle.blackKing = false
                    canCastle.blackQueen = false
                }
                if abs(move.to.x-move.from.x) == 2 {
                    board[move.to.y][move.to.x] = board[move.from.y][move.from.x]
                    board[move.from.y][move.from.x] = nil
                    if move.to.x-move.from.x == 2 {
                        board[move.to.y][move.to.x-1] = board[move.to.y][move.to.x+1]
                        board[move.to.y][move.to.x+1] = nil
                    } else if move.to.x-move.from.x == -2 {
                        board[move.to.y][move.to.x+1] = board[move.to.y][move.to.x-2]
                        board[move.to.y][move.to.x-2] = nil
                    }
                    turn.toggle()
                    fenMoves.append(self.fen)
                    return .success
                }
            }
            // remove castling rights if rook moves
            if board[move.from.y][move.from.x] is Rook {
                if move.from.y == 0 && move.from.x == 7 {
                    canCastle.whiteKing = false
                } else if move.from.y == 0 && move.from.x == 0 {
                    canCastle.whiteQueen = false
                } else if move.from.y == 7 && move.from.x == 7 {
                    canCastle.blackKing = false
                } else if move.from.y == 7 && move.from.x == 0 {
                    canCastle.blackQueen = false
                }
            }
            // handle moves associated with pawn moves; promotion, en passant priveleges
            if board[move.from.y][move.from.x] is Pawn {
                halfmoveClock = 0
                // if pawn is moving 2 squares, calculate en passant priveleges for next turn
                if abs(move.to.y-move.from.y) == 2 {
                    if let piece = board[move.to.y][safe: move.to.x+1] {
                        if piece is Pawn && piece?.color == turn.opposite {
                            if turn == .white {
                                enPassantSquare = (x: move.to.x, y: move.to.y-1)
                            } else {
                                enPassantSquare = (x: move.to.x, y: move.to.y+1)
                            }
                        }
                    }
                    if let piece = board[move.to.y][safe: move.to.x-1] {
                        if piece is Pawn && piece?.color == turn.opposite {
                            if turn == .white {
                                enPassantSquare = (x: move.to.x, y: move.to.y-1)
                            } else {
                                enPassantSquare = (x: move.to.x, y: move.to.y+1)
                            }
                        }
                    }
                }
                // check for promotion
                if turn == .white {
                    if move.to.y == 7 {
                        var piece: Piece {
                            switch promotion {
                            case .bishop:
                                return Bishop(color: .white)
                            case .knight:
                                return Knight(color: .white)
                            case .rook:
                                return Rook(color: .white)
                            default:
                                return Queen(color: .white)
                            }
                        }
                        board[move.to.y][move.to.x] = piece
                        board[move.from.y][move.from.x] = nil
                        turn.toggle()
                        fenMoves.append(self.fen)
                        return .success
                    }
                } else {
                    if move.to.y == 0 {
                        var piece: Piece {
                            switch promotion {
                            case .bishop:
                                return Bishop(color: .black)
                            case .knight:
                                return Knight(color: .black)
                            case .rook:
                                return Rook(color: .black)
                            default:
                                return Queen(color: .black)
                            }
                        }
                        board[move.to.y][move.to.x] = piece
                        board[move.from.y][move.from.x] = nil
                        turn.toggle()
                        fenMoves.append(self.fen)
                        return .success
                    }
                }
            }
            // set move to square to move from square
            // set move from square to nil
            // toggle turn
            // append current board to board array
            board[move.to.y][move.to.x] = board[move.from.y][move.from.x]
            board[move.from.y][move.from.x] = nil
            turn.toggle()
            fenMoves.append(self.fen)
            return .success
        }
        return .error
    }
}
