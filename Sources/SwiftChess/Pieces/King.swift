//
//  King.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/8/21.
//

import Foundation

struct King: Piece {
    var color: PieceColor
    
    func attackingSquares(x: Int, y: Int, board: [[Piece?]]) -> [(Int, Int)] {
        var attacking = [(Int, Int)]()
        let offsets = [
            (x+1, y),
            (x+1, y+1),
            (x+1, y-1),
            (x, y+1),
            (x, y-1),
            (x-1, y),
            (x-1, y+1),
            (x-1, y-1),
        ]
        for offset in offsets {
            if (board[safe: offset.1]?[safe: offset.0]) != nil {
                attacking.append(offset)
            }
        }
        
        return attacking
    }
    
    func moves(x: Int, y: Int, board: [[Piece?]]) -> [Move] {
        var moves = [Move]()
        let offsets = [
            (x+1, y),
            (x+1, y+1),
            (x+1, y-1),
            (x, y+1),
            (x, y-1),
            (x-1, y),
            (x-1, y+1),
            (x-1, y-1),
        ]
        for offset in offsets {
            if let position = board[safe: offset.1]?[safe: offset.0] {
                if position == nil || position?.color == color.opposite {
                    moves.append(Move(from: (x, y), to: offset))
                }
            }
        }
        return moves
    }
}
