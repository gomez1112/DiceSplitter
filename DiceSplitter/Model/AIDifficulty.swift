//
//  AIDifficulty.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 6/5/25.
//

import Foundation

enum AIDifficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case expert = "Expert"
    
    var thinkingTime: Double {
        switch self {
            case .easy: return 0.3
            case .medium: return 0.5
            case .hard: return 0.7
            case .expert: return 1.0
        }
    }
    
    var searchDepth: Int {
        switch self {
            case .easy: return 1
            case .medium: return 2
            case .hard: return 3
            case .expert: return 4
        }
    }

}
