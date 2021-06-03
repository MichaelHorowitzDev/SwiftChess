//
//  RemoveLastExtension.swift
//  Chess SwiftUI
//
//  Created by Michael Horowitz on 5/25/21.
//

import Foundation

extension String {
    /// Returns an array with the specified number of elements removed from the end.
    func removingLast(_ k: Int) -> String {
        return Array(Array(self).dropLast(k).map {String($0)}).joined()
    }
    /// Returns an array with elements removed up to and including a specified String.
    func removingUpTo(_ s: String) -> String {
        if self.count > 0 && self.contains(s) {
            var array = Array(self).map {String($0)}
            while String(array.last!) != s {
                array.removeLast()
            }
            array.removeLast()
            return array.joined()
        } else {
            return self
        }
    }
}
