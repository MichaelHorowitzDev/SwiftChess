//
//  ChessViewModel.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/30/21.
//

import SwiftUI
import SwiftChess
class ChessViewModel: ObservableObject {
    @Published var game: Game
    @Published var highlightedPieces = [(Int, Int)]()
    @Published var attackedSquares = [(Int, Int)]()
    @Published var move: Move?
    @Published var invalidFen = false
    @Published var fen = "" {
        didSet {
            let fen = FEN(fen: fen)
            if fen.isValid {
                self.game.changeFEN(fen: fen)
            } else {
                invalidFen = true
            }
        }
    }
    @Published var promotionSelection = false
    @Published var promotionPiece: Promotion {
        didSet {
            if move != nil {
                game.makeMove(move: move!, promotionPiece)
                attackedSquares = game.board.squaresAttacked()
                selectedPiece = nil
            }
            promotionSelection = false
        }
    }
    @Published var selectedPiece: (Int, Int)? {
        didSet {
            highlightedPieces.removeAll()
            self.move = nil
            attackedSquares = game.board.squaresAttacked()
            if oldValue != nil && selectedPiece != nil {
                let move = Move(from: oldValue!, to: selectedPiece!)
                self.move = move
                if game.canMove(move: move) {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    if game.willPromote(move: move) {
                        promotionSelection = true
                        return
                    }
                    game.makeMove(move: move, forced: true)
                    attackedSquares = game.board.squaresAttacked()
                    selectedPiece = nil
                }
            }
            if selectedPiece != nil {
                if game.board.board[selectedPiece!.1][selectedPiece!.0] == nil || game.board.board[selectedPiece!.1][selectedPiece!.0]?.color != game.turn {
                    selectedPiece = nil
                } else {
                    if game.board.moveForPiece(at: selectedPiece!).count > 0 {
                        let moves = game.board.moveForPiece(at: selectedPiece!)
                        for move in moves {
                            highlightedPieces.append(move.to)
                        }
                    }
                }
            }
            self.move = nil
        }
    }
    
    init(game: Game) {
        self.game = game
        self.attackedSquares = game.board.squaresAttacked()
        self.promotionPiece = .queen
    }
}
