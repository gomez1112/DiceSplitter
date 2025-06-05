//
//  Achievement.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 6/5/25.
//

import Foundation

struct Achievement: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let icon: String
    
    static let firstVictory = Achievement(
        id: "first_victory",
        name: "First Victory",
        description: "Win your first game",
        icon: "trophy"
    )
    
    static let tenWins = Achievement(
        id: "ten_wins",
        name: "Getting Good",
        description: "Win 10 games",
        icon: "star.fill"
    )
    
    static let fiftyWins = Achievement(
        id: "fifty_wins",
        name: "Veteran",
        description: "Win 50 games",
        icon: "medal.fill"
    )
    
    static let centurion = Achievement(
        id: "centurion",
        name: "Centurion",
        description: "Win 100 games",
        icon: "crown.fill"
    )
    
    static let onFire = Achievement(
        id: "on_fire",
        name: "On Fire",
        description: "Win 5 games in a row",
        icon: "flame.fill"
    )
    
    static let unstoppable = Achievement(
        id: "unstoppable",
        name: "Unstoppable",
        description: "Win 10 games in a row",
        icon: "bolt.fill"
    )
    
    static let speedDemon = Achievement(
        id: "speed_demon",
        name: "Speed Demon",
        description: "Win a game in under 30 seconds",
        icon: "hare.fill"
    )
    
    static let expertSlayer = Achievement(
        id: "expert_slayer",
        name: "Expert Slayer",
        description: "Beat the Expert AI",
        icon: "brain"
    )
    
    static let masterTactician = Achievement(
        id: "master_tactician",
        name: "Master Tactician",
        description: "Beat Expert AI 10 times",
        icon: "chess.king.fill"
    )
    
    static let bigBoardMaster = Achievement(
        id: "big_board_master",
        name: "Big Board Master",
        description: "Win on a 10x10 or larger board",
        icon: "square.grid.3x3.fill"
    )
    
    static let dedicated = Achievement(
        id: "dedicated",
        name: "Dedicated Player",
        description: "Play 100 games",
        icon: "heart.fill"
    )
    
    static let consistent = Achievement(
        id: "consistent",
        name: "Consistent Winner",
        description: "Maintain 75% win rate over 20 games",
        icon: "chart.line.uptrend.xyaxis"
    )
    
    static let allAchievements: [Achievement] = [
        .firstVictory, .tenWins, .fiftyWins, .centurion,
        .onFire, .unstoppable, .speedDemon, .expertSlayer,
        .masterTactician, .bigBoardMaster, .dedicated, .consistent
    ]
}

extension Notification.Name {
    static let achievementUnlocked = Notification.Name("achievementUnlocked")
}
