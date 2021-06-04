//
//  Bishop.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/8/21.
//

import Foundation

public struct Bishop: Piece {
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
        
        while yLocation < board.count-1 && xLocation < board[y].count-1 {
            xLocation+=1
            yLocation+=1
            
            if board[yLocation][xLocation] == nil {
                attacking.append((xLocation, yLocation))
            } else {
                attacking.append((xLocation, yLocation))
                break
            }
        }
        
        xLocation = x
        yLocation = y
        while yLocation > 0 && xLocation > 0 {
            xLocation-=1
            yLocation-=1
            
            if board[yLocation][xLocation] == nil {
                attacking.append((xLocation, yLocation))
            } else {
                attacking.append((xLocation, yLocation))
                break
            }
        }
        
        xLocation = x
        yLocation = y
        while yLocation < board.count-1 && xLocation > 0 {
            xLocation-=1
            yLocation+=1
            
            if board[yLocation][xLocation] == nil {
                attacking.append((xLocation, yLocation))
            } else {
                attacking.append((xLocation, yLocation))
                break
            }
        }
        
        xLocation = x
        yLocation = y
        while yLocation > 0 && xLocation < board[y].count-1 {
            xLocation+=1
            yLocation-=1
            
            if board[yLocation][xLocation] == nil {
                attacking.append((xLocation, yLocation))
            } else {
                attacking.append((xLocation, yLocation))
                break
            }
        }
        return attacking
    }
    
    func moves(x: Int, y: Int, board: [[Piece?]]) -> [Move] {
        var moves = [Move]()
        var xLocation = x
        var yLocation = y
        
        while yLocation < board.count-1 && xLocation < board[y].count-1 {
            xLocation+=1
            yLocation+=1
            
            if board[yLocation][xLocation] == nil {
                moves.append(Move(from: (x, y), to: (xLocation, yLocation)))
            } else if board[yLocation][xLocation]?.color == color.opposite {
                moves.append(Move(from: (x, y), to: (xLocation, yLocation)))
                break
            } else {
                break
            }
        }
        
        xLocation = x
        yLocation = y
        while yLocation > 0 && xLocation > 0 {
            xLocation-=1
            yLocation-=1
            
            if board[yLocation][xLocation] == nil {
                moves.append(Move(from: (x, y), to: (xLocation, yLocation)))
            } else if board[yLocation][xLocation]?.color == color.opposite {
                moves.append(Move(from: (x, y), to: (xLocation, yLocation)))
                break
            } else {
                break
            }
        }
        
        xLocation = x
        yLocation = y
        while yLocation < board.count-1 && xLocation > 0 {
            xLocation-=1
            yLocation+=1
            
            if board[yLocation][xLocation] == nil {
                moves.append(Move(from: (x, y), to: (xLocation, yLocation)))
            } else if board[yLocation][xLocation]?.color == color.opposite {
                moves.append(Move(from: (x, y), to: (xLocation, yLocation)))
                break
            } else {
                break
            }
        }
        
        xLocation = x
        yLocation = y
        while yLocation > 0 && xLocation < board[y].count-1 {
            xLocation+=1
            yLocation-=1
            
            if board[yLocation][xLocation] == nil {
                moves.append(Move(from: (x, y), to: (xLocation, yLocation)))
            } else if board[yLocation][xLocation]?.color == color.opposite {
                moves.append(Move(from: (x, y), to: (xLocation, yLocation)))
                break
            } else {
                break
            }
        }
        return moves
    }
}
