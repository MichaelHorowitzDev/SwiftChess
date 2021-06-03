//
//  Rook.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/6/21.
//

import Foundation

struct Rook: Piece {
    var color: PieceColor
    
    func attackingSquares(x: Int, y: Int, board: [[Piece?]]) -> [(Int, Int)] {
        var board = board
        for rank in 0...board.count-1 {
            for item in 0...board[rank].count-1 {
                if board[rank][item] is King {
                    board[rank][item] = nil
                }
            }
        }
        var attacking = [(Int, Int)]()
        var xLocation = x
        var yLocation = y
        while xLocation < board[y].count-1 {
            xLocation+=1
            if board[y][xLocation] == nil {
                attacking.append((xLocation, yLocation))
            } else {
                attacking.append((xLocation, y))
                break
            }
        }
        xLocation = x
        while xLocation > 0 {
            xLocation-=1
            if board[y][xLocation] == nil {
                attacking.append((xLocation, y))
            } else {
                attacking.append((xLocation, y))
                break
            }
        }
        while yLocation < board.count-1 {
            yLocation+=1
            if board[yLocation][x] == nil {
                attacking.append((x, yLocation))
            } else {
                attacking.append((x, yLocation))
                break
            }
        }
        yLocation = y
        while yLocation > 0 {
            yLocation-=1
            if board[yLocation][x] == nil {
                attacking.append((x, yLocation))
            } else {
                attacking.append((x, yLocation))
                break
            }
        }
        return attacking
    }
    
    func moves(x: Int, y: Int, board: [[Piece?]]) -> [Move] {
        var moves = [Move]()
        var xLocation = x
        var yLocation = y
        while xLocation < board[y].count-1 {
            xLocation+=1
            if board[y][xLocation] == nil {
                moves.append(Move(from: (x, y), to: (xLocation, y)))
            } else if board[y][xLocation]?.color == color.opposite {
                moves.append(Move(from: (x, y), to: (xLocation, y)))
                break
            } else {
                break
            }
        }
        xLocation = x
        while xLocation > 0 {
            xLocation-=1
            if board[y][xLocation] == nil {
                moves.append(Move(from: (x, y), to: (xLocation, y)))
            } else if board[y][xLocation]?.color == color.opposite {
                moves.append(Move(from: (x, y), to: (xLocation, y)))
                break
            } else {
                break
            }
        }
        while yLocation < board.count-1 {
            yLocation+=1
            if board[yLocation][x] == nil {
                moves.append(Move(from: (x, y), to: (x, yLocation)))
            } else if board[yLocation][x]?.color == color.opposite {
                moves.append(Move(from: (x, y), to: (x, yLocation)))
                break
            } else {
                break
            }
        }
        yLocation = y
        while yLocation > 0 {
            yLocation-=1
            if board[yLocation][x] == nil {
                moves.append(Move(from: (x, y), to: (x, yLocation)))
            } else if board[yLocation][x]?.color == color.opposite {
                moves.append(Move(from: (x, y), to: (x, yLocation)))
                break
            } else {
                break
            }
        }
        return moves
    }
}
