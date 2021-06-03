//
//  FEN.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/23/21.
//

import Foundation

struct FEN {
    var fen: String
    var board: Board
    var isValid: Bool = true
    
    init(board: Board) {
        self.fen = boardToFen(board: board)
        self.board = board
    }
    init(fen: String) {
        self.fen = fen
        let fenBoard = fenToBoard(fen: fen)
        if fenBoard == nil {
            isValid = false
        }
        self.board = fenBoard ?? Board()
    }
}

func boardToFen(board: Board) -> String {
    var string = ""
    var dataFields = [String]()
    var blankSquares = 0
    
    // loop through ranks starting from 8th
    for rank in board.board.reversed() {
        for (index, square) in rank.enumerated() {
            // check if square is a piece
            var piece = ""
            switch square {
            case is Pawn:
                piece = "p"
            case is Rook:
                piece = "r"
            case is Knight:
                piece = "n"
            case is Bishop:
                piece = "b"
            case is Queen:
                piece = "q"
            case is King:
                piece = "k"
            default:
                // is blank square
                blankSquares+=1
                if index == 7 {
                    string.append(blankSquares.description)
                    blankSquares = 0
                }
                continue
            }
            if square?.color == .white {
                piece = piece.capitalized
            }
            if blankSquares != 0 {
                string.append(blankSquares.description)
                blankSquares = 0
            }
            string.append(piece)
        }
        string.append("/")
    }
    string.removeLast()
    dataFields.append(string)
    string = board.turn == .white ? "w" : "b"
    dataFields.append(string)
    string = ""
    if board.canCastle.whiteKing {
        string.append("K")
    }
    if board.canCastle.whiteQueen {
        string.append("Q")
    }
    if board.canCastle.blackKing {
        string.append("k")
    }
    if board.canCastle.blackQueen {
        string.append("q")
    }
    if string == "" {
        string = "-"
    }
    dataFields.append(string)
    string = "-"
    if board.enPassantSquare != nil {
        let ranks = [0:"1", 1:"2", 2:"3", 3:"4", 4:"5", 5:"6", 6:"7", 7:"8"]
        let files = [0:"a", 1:"b", 2:"c", 3:"d", 4:"e", 5:"f", 6:"g", 7:"h"]
        if files[board.enPassantSquare!.x] != nil && ranks[board.enPassantSquare!.y] != nil {
            string = files[board.enPassantSquare!.x]!+ranks[board.enPassantSquare!.y]!
        }
    }
    dataFields.append(string)
    string = board.halfmoveClock.description
    dataFields.append(string)
    string = board.fullmoveNumber.description
    dataFields.append(string)
    let fen = dataFields.joined(separator: " ")
    return fen
}

func fenToBoard(fen: String) -> Board? {
    var board = [[Piece?]]()
    let fenParts = fen.split(separator: " ")
    if fenParts.count != 6 {
        return nil
    }
    let boardRanks = fenParts[0].split(separator: "/")
    for rank in boardRanks.reversed() {
         var boardRank = [Piece?]()
        for item in rank {
            let piece: Piece?
            switch item.lowercased() {
            case "r":
                piece = Rook(color: item.isLowercase ? .black : .white)
            case "n":
                piece = Knight(color: item.isLowercase ? .black : .white)
            case "b":
                piece = Bishop(color: item.isLowercase ? .black : .white)
            case "q":
                piece = Queen(color: item.isLowercase ? .black : .white)
            case "k":
                piece = King(color: item.isLowercase ? .black : .white)
            case "p":
                piece = Pawn(color: item.isLowercase ? .black : .white)
            default:
                // for blank squares
                if let num = Int(item.description) {
                    for _ in 0..<num {
                        boardRank.append(nil)
                    }
                }
                continue
            }
            boardRank.append(piece)
        }
        if boardRank.count != 8 {
            return nil
        }
        board.append(boardRank)
    }
    if board.count != 8 {
        return nil
    }
    let turn: PieceColor
    if fenParts[1] == "w" {
        turn = .white
    } else if fenParts[1] == "b" {
        turn = .black
    } else {
        return nil
    }
    let canCastle = (fenParts[2].contains("K"), fenParts[2].contains("Q"), fenParts[2].contains("k"), fenParts[2].contains("q"))
    let ranks = ["1":0, "2":1, "3":2, "4":3, "5":4, "6":5, "7":6, "8":7]
    let files = ["a":0, "b":1, "c":2, "d":3, "e":4, "f":5, "g":6, "h":7]
    let enPassantSquare: (x: Int, y: Int)?
    if fenParts[3] == "-" {
        enPassantSquare = nil
    } else if fenParts[3].count == 2 {
        if files.keys.contains(String(fenParts[3].first!)) && ranks.keys.contains(String(fenParts[3].last!)) {
            enPassantSquare = (x: files[String(fenParts[3].first!)]!, y: ranks[String(fenParts[3].last!)]!)
        } else {
            return nil
        }
    } else {
        return nil
    }
    guard let halfmoveClock = Int(fenParts[4]) else { return nil }
    guard let fullmoveNumber = Int(fenParts[5]) else { return nil }
    return Board(board: board, turn: turn, canCastle: canCastle, halfmoveClock: halfmoveClock, fullmoveNumber: fullmoveNumber, enPassantSquare: enPassantSquare)
}
