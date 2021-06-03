//
//  Move.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/6/21.
//

import Foundation

public struct Move: Equatable {
    static func == (lhs: Move, rhs: Move) -> Bool {
        return lhs.from == rhs.from && lhs.to == rhs.to
    }
    let from: (x: Int, y: Int)
    let to: (x: Int, y: Int)
    let pieceMoved: Piece? = nil
    let captures: Bool = false
}
