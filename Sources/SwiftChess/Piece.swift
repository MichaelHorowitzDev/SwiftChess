//
//  Piece.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/6/21.
//

import Foundation

public enum PieceColor {
    case white, black
    var opposite: PieceColor {
        return self == .white ? .black : .white
    }
    mutating func toggle() {
        self = self.opposite
    }
}

public enum Promotion {
    case queen, rook, knight, bishop
}

public enum GameState {
    case playing, check, checkmate, stalemate, repetition, moveRule
}

public enum MoveResult {
    case success, error
}

public protocol Piece {
    public var color: PieceColor { get }
    public func moves(x: Int, y: Int, board: [[Piece?]]) -> [Move]
    public func attackingSquares(x: Int, y: Int, board: [[Piece?]]) -> [(Int, Int)]
}
