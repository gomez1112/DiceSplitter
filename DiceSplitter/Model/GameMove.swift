//
//  GameMove.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 6/5/25.
//

import Foundation

struct GameMove {
    let dice: Dice
    let previousValue: Int
    let previousOwner: Player
    let affectedDice: [(dice: Dice, previousValue: Int, previousOwner: Player)]
}
