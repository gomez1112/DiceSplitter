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
class Dice: Equatable, Identifiable {
    var value = 1
    var changeAmount = 0.0
    var owner = Player.none
    let id = UUID()
    var row: Int
    var column: Int
    var neighbors: Int
    
    init(row: Int, column: Int, neighbors: Int) {
        self.row = row
        self.column = column
        self.neighbors = neighbors
    }
    
    nonisolated static func == (lhs: Dice, rhs: Dice) -> Bool {
        lhs.id == rhs.id
    }
}
