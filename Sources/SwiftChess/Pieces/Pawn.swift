//
//  Pawn.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/6/21.
//

import Foundation

struct Pawn: Piece {
    var color: PieceColor
    
    func attackingSquares(x: Int, y: Int, board: [[Piece?]]) -> [(Int, Int)] {
        var attacking = [(Int, Int)]()
        if color == .white {
            if y < board.count-1 {
                if x < board[y].count-1 {
                    attacking.append((x+1, y+1))
                }
                if x > 0 {
                    attacking.append((x-1, y+1))
                }
            }
        } else {
            if y > 0 {
                if x < board[y].count-1 {
                    attacking.append((x+1, y-1))
                }
                if x > 0 {
                    attacking.append((x-1, y-1))
                }
            }
        }
        return attacking
    }
    
    func moves(x: Int, y: Int, board: [[Piece?]]) -> [Move] {
        var moves = [Move]()
        if color == .white {
            //piece is on last rank
            if y == board.count-1 {
                return moves
            }
            //piece can move forward 1
            if board[y+1][x] == nil {
                moves.append(Move(from: (x, y), to: (x, y+1)))
            }
            //piece is on second rank and can move 2
            if y == 1 {
                if board[y+1][x] == nil && board[y+2][x] == nil {
                    moves.append(Move(from: (x, y), to: (x, y+2)))
                }
            }
            //piece is capable of capturing diagonal right
            if x == 0 || x < board[y].count-1 {
                if board[y+1][x+1] != nil && board[y+1][x+1]?.color != .white {
                    moves.append(Move(from: (x, y), to: (x+1, y+1)))
                }
            }
            //piece is capable of capturing diagonal left
            if x == board[y].count-1 || x > 0 {
                if board[y+1][x-1] != nil && board[y+1][x-1]?.color != .white {
                    moves.append(Move(from: (x, y), to: (x-1, y+1)))
                }
            }
            //en passant right
            if x < board[y].count-1 {
                if let pawn = board[y][x+1] as? Pawn {
                    if pawn.color == .black {
                        moves.append(Move(from: (x, y), to: (x+1, y+1)))
                    }
                }
            }
            //en passant left
            if x > 0 {
                if let pawn = board[y][x-1] as? Pawn {
                    if pawn.color == .black {
                        moves.append(Move(from: (x, y), to: (x-1, y+1)))
                    }
                }
            }
        } else {
            if y == 0 {
                return moves
            }
            if board[y-1][x] == nil {
                moves.append(Move(from: (x, y), to: (x, y-1)))
            }
            if y == board.count-2 {
                if board[y-1][x] == nil && board[y-2][x] == nil {
                    moves.append(Move(from: (x, y), to: (x, y-2)))
                }
            }
            if x == 0 || x < board[y].count-1 {
                if board[y-1][x+1] != nil && board[y-1][x+1]?.color != .black {
                    moves.append(Move(from: (x, y), to: (x+1, y-1)))
                }
            }
            if x == board[y].count-1 || x > 0 {
                if board[y-1][x-1] != nil && board[y-1][x-1]?.color != .black {
                    moves.append(Move(from: (x, y), to: (x-1, y-1)))
                }
            }
            //en passant left
            if x > 0 {
                if let pawn = board[y][x-1] as? Pawn {
                    if pawn.color == .white {
                        moves.append(Move(from: (x, y), to: (x-1, y-1)))
                    }
                }
            }
            //en passant right
            if x < board[y].count-1 {
                if let pawn = board[y][x+1] as? Pawn {
                    if pawn.color == .white {
                        moves.append(Move(from: (x, y), to: (x+1, y-1)))
                    }
                }
            }
        }
        return moves
    }
}
