//
//  Game.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/11/21.
//

import Foundation

struct Game {
    var pgnMoves = [String]()
    var board: Board
    var gameState: GameState
    var turn: PieceColor
    
    // make move on board but also check for gamestate
    @discardableResult
    mutating func makeMove(move: Move, forced: Bool = false, _ promotion: Promotion = .queen) -> MoveResult {
        var moveResult: MoveResult = .error
        if gameState == .playing || gameState == .check {
            if board.makeMove(move: move, forced: forced, promotion) == .success {
                turn = board.turn
                moveResult = .success
                gameState = board.gameState()
                switch gameState {
                case .check:
                    print("check")
                case .checkmate:
                    print("checkmate")
                case .stalemate:
                    print("stalemate")
                case .repetition:
                    print("repetition")
                case .moveRule:
                    print("50 move rule")
                default:
                    print("playing")
                }
            }
        }
        return moveResult
    }
    mutating func canMove(move: Move) -> Bool {
        return board.canMove(move: move)
    }
    mutating func willPromote(move: Move) -> Bool {
        return board.willPromote(move: move)
    }
    mutating func undoMove() {
        board.undoMove()
        gameState = board.gameState()
        turn = board.turn
    }
    
    init(board: Board) {
        self.board = board
        self.gameState = self.board.gameState()
        self.turn = self.board.turn
    }
    
    init() {
        self.board = Board()
        self.gameState = .playing
        self.turn = self.board.turn
    }
    mutating func changeFEN(fen: FEN) {
        board = fen.board
        gameState = self.board.gameState()
        turn = self.board.turn
        pgnMoves.removeAll()
    }
//    TODO
     // Eventually be able to convert game move to PGN
    private mutating func moveToPGNMove(move: Move, pieceMoved: Piece, pieceCaptured: Bool, turn: PieceColor) -> String {
        let ranks = [0:"1", 1:"2", 2:"3", 3:"4", 4:"5", 5:"6", 6:"7", 7:"8"]
        let files = [0:"a", 1:"b", 2:"c", 3:"d", 4:"e", 5:"f", 6:"g", 7:"h"]
        var piece: String
        switch pieceMoved {
        case is Bishop:
            piece = "B"
        case is Knight:
            piece = "N"
        case is Rook:
            piece = "R"
        case is Queen:
            piece = "Q"
        case is King:
            piece = "K"
        default:
            piece = ""
        }
        let gameNumber = turn == .white ? String(pgnMoves.count/2+1)+". " : ""
        let captured = pieceCaptured ? "x" : ""
        if piece == "" && captured == "x" {
            piece = files[move.from.x]!
        }
        let toLocation = (files[move.to.x]! + ranks[move.to.y]!)
        var check: String {
            switch board.gameState() {
            case .check:
                return "+"
            case .checkmate:
                return "#"
            default:
                return ""
            }
        }
        return gameNumber+piece+captured+toLocation+check
    }
}
