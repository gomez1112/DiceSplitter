//
//  Statistics.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 6/5/25.
//

import Foundation
import SwiftData

@Model
class Statistics {
    var totalGamesPlayed = 0
    var totalWins = 0
    var totalLosses = 0
    var totalDraws = 0
    var winStreak = 0
    var bestWinStreak = 0
    var totalMovesPlayed = 0
    var fastestWin: TimeInterval = 999999.0
    var largestBoardConquered = 0
    var unlockedAchievementIDs: [String] = []
    
    // Per-difficulty statistics
    var easyWins = 0
    var mediumWins = 0
    var hardWins = 0
    var expertWins = 0
    
    init() {
        // Default initializer for SwiftData
    }
    
    var winRate: Double {
        guard totalGamesPlayed > 0 else { return 0 }
        return Double(totalWins) / Double(totalGamesPlayed) * 100
    }
    
    // FIXED: Added validation and error handling
    func recordGameResult(winner: Player?, playerType: PlayerType, boardSize: Int, duration: TimeInterval, moves: Int, difficulty: AIDifficulty) {
        // Validate inputs
        guard boardSize > 0, duration >= 0, moves >= 0 else {
            print("Invalid game result parameters")
            return
        }
        
        totalGamesPlayed += 1
        totalMovesPlayed += moves
        
        if playerType == .ai {
            if winner == .green {
                totalWins += 1
                winStreak += 1
                bestWinStreak = max(bestWinStreak, winStreak)
                
                // FIXED: Only record fastest win if it's a valid time
                if duration > 0 && duration < fastestWin {
                    fastestWin = duration
                    checkAchievement(.speedDemon)
                }
                
                if boardSize > largestBoardConquered {
                    largestBoardConquered = boardSize
                }
                
                // Record difficulty-specific wins
                switch difficulty {
                    case .easy: easyWins += 1
                    case .medium: mediumWins += 1
                    case .hard: hardWins += 1
                    case .expert: expertWins += 1
                }
                
                checkWinAchievements()
            } else if winner == nil {
                totalDraws += 1
                winStreak = 0
            } else {
                totalLosses += 1
                winStreak = 0
            }
        }
        
        checkGeneralAchievements()
    }
    
    private func checkWinAchievements() {
        if totalWins >= 1 { checkAchievement(.firstVictory) }
        if totalWins >= 10 { checkAchievement(.tenWins) }
        if totalWins >= 50 { checkAchievement(.fiftyWins) }
        if totalWins >= 100 { checkAchievement(.centurion) }
        if winStreak >= 5 { checkAchievement(.onFire) }
        if winStreak >= 10 { checkAchievement(.unstoppable) }
        if expertWins >= 1 { checkAchievement(.expertSlayer) }
        if expertWins >= 10 { checkAchievement(.masterTactician) }
    }
    
    private func checkGeneralAchievements() {
        if totalGamesPlayed >= 100 { checkAchievement(.dedicated) }
        if largestBoardConquered >= 100 { checkAchievement(.bigBoardMaster) }
        if winRate >= 75 && totalGamesPlayed >= 20 { checkAchievement(.consistent) }
    }
    
    private func checkAchievement(_ achievement: Achievement) {
        if !unlockedAchievementIDs.contains(achievement.id) {
            unlockedAchievementIDs.append(achievement.id)
            // Trigger notification
            NotificationCenter.default.post(
                name: .achievementUnlocked,
                object: achievement
            )
        }
    }
    
    func isAchievementUnlocked(_ achievement: Achievement) -> Bool {
        unlockedAchievementIDs.contains(achievement.id)
    }
    
    func resetStatistics() {
        totalGamesPlayed = 0
        totalWins = 0
        totalLosses = 0
        totalDraws = 0
        winStreak = 0
        bestWinStreak = 0
        totalMovesPlayed = 0
        fastestWin = 999999.0
        largestBoardConquered = 0
        easyWins = 0
        mediumWins = 0
        hardWins = 0
        expertWins = 0
        // Keep achievements unlocked
    }
    
    // FIXED: Added computed property for formatted fastest win
    var formattedFastestWin: String? {
        guard fastestWin < 999999.0 else { return nil }
        let minutes = Int(fastestWin) / 60
        let seconds = Int(fastestWin) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
