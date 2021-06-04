//
//  Move.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/6/21.
//

import Foundation

public struct Move: Equatable {
    public static func == (lhs: Move, rhs: Move) -> Bool {
        return lhs.from == rhs.from && lhs.to == rhs.to
    }
    public let from: (x: Int, y: Int)
    public let to: (x: Int, y: Int)
    public let pieceMoved: Piece? = nil
    public let captures: Bool = false
    
    public init(from: (x: Int, y: Int), to: (x: Int, y: Int)) {
        self.from = from
        self.to = to
    }
    
//     init(from: (x: Int, y: Int), to: (x: Int, y: Int), pieceMoved: Piece? = nil, captures: Bool = false) {
//         self.from = (x: from.x-1, y: from.y-1)
//         self.to = (x: to.x-1, y: to.y-1)
//         self.pieceMoved = pieceMoved
//         self.captures = captures
//     }
}
