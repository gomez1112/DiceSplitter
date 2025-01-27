//
//  Dice.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import Foundation
import Observation

@Observable
@MainActor
final class Dice: Equatable, Identifiable {
    var value = 1
    var changeAmount = 0.0
    var owner = Player.none
    let id = UUID()
    let row: Int
    let column: Int
    let neighbors: Int
    
    nonisolated static func == (lhs: Dice, rhs: Dice) -> Bool {
        lhs.id == rhs.id
    }
    
    init(row: Int, column: Int, neighbors: Int) {
        self.row = row
        self.column = column
        self.neighbors = neighbors
    }
}
