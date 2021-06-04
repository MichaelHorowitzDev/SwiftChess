//
//  Knight.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/8/21.
//

import Foundation

public struct Knight: Piece {
   public var color: PieceColor
    
    public func attackingSquares(x: Int, y: Int, board: [[Piece?]]) -> [(Int, Int)] {
        var attacking = [(Int, Int)]()
        let offsets = [
            (x+1, y+2),
            (x+1, y-2),
            (x-1, y+2),
            (x-1, y-2),
            (x-2, y+1),
            (x-2, y-1),
            (x+2, y-1),
            (x+2, y+1)
        ]
        for offset in offsets {
            if (board[safe: offset.1]?[safe: offset.0]) != nil {
                attacking.append((offset.0, offset.1))
            }
        }
        return attacking
    }
    
    public func moves(x: Int, y: Int, board: [[Piece?]]) -> [Move] {
        var moves = [Move]()
        let offsets = [
            (x+1, y+2),
            (x+1, y-2),
            (x-1, y+2),
            (x-1, y-2),
            (x-2, y+1),
            (x-2, y-1),
            (x+2, y-1),
            (x+2, y+1)
        ]
        for offset in offsets {
            if let position = board[safe: offset.1]?[safe: offset.0] {
                if position == nil || (position != nil && position?.color == color.opposite) {
                    moves.append(Move(from: (x, y), to: (offset.0, offset.1)))
                }
            }
        }
        return moves
    }
}
