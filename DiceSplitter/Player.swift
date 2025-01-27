//
//  Player.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import Foundation
import SwiftUI

enum Player: Identifiable, CaseIterable {
    case none
    case green
    case red
    case blue
    case yellow
    
    var id: Self { self }
    var displayName: String {
        switch self {
            case .green: "Green"
            case .red: "Red"
            case .none: "None"
            case .blue: "Blue"
            case .yellow: "Yellow"
        }
    }
    var color: Color {
        switch self {
            case .green: .green
            case .red: .red
            case .none: Color(white: 0.6)
            case .blue: .blue
            case .yellow: .yellow
        }
    }
    static var allPlayers: [Player] {
        [.green, .red, .blue, .yellow]
    }
}

enum PlayerType {
    case ai, human
}
