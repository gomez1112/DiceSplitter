//
//  ContentView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var game: Game?
    @State private var mapSize = CGSize(width: 6, height: 6)
    @State private var playerType: PlayerType = .ai
    @State private var numberOfPlayers = 3
    @State private var aiDifficulty: AIDifficulty = .medium
    @Query private var stats: [Statistics]
    @Environment(\.modelContext) private var modelContext

    private var stat: Statistics {
        // Get or create statistics
        if let existingStats = stats.first {
            return existingStats
        }
        let newStats = Statistics()
        modelContext.insert(newStats)
        try? modelContext.save()
        return newStats
    }
    var body: some View {
#if os(macOS)
        contentBody
            .frame(minWidth: 800, minHeight: 600)
#else
        contentBody
#endif
    }
    
    var contentBody: some View {
        NavigationStack {
            if hasCompletedOnboarding {
                if let game {
                    ZStack {
                        GameView(
                            game: game,
                            mapSize: $mapSize,
                            playerType: $playerType,
                            numberOfPlayers: $numberOfPlayers,
                            aiDifficulty: $aiDifficulty,
                            resetGame: {
                                startGame()
                            }, stats: stat
                        )
                    }
                } else {
                    SettingsView(
                        mapSize: $mapSize,
                        playerType: $playerType,
                        numberOfPlayers: $numberOfPlayers,
                        aiDifficulty: $aiDifficulty,
                        showingWarning: false,
                        startGame: startGame
                    )
                }
            } else {
                OnboardingView(
                    mapSize: $mapSize,
                    playerType: $playerType,
                    numberOfPlayers: $numberOfPlayers,
                    aiDifficulty: $aiDifficulty
                ) {
                    hasCompletedOnboarding = true
                    startGame()
                }
            }
        }
    }
    
    private func startGame() {
        let width = max(3, Int(mapSize.width))
        let height = max(3, Int(mapSize.height))
        
        withAnimation(.easeInOut(duration: 0.3)) {
            game = Game(
                rows: width,
                columns: height,
                playerType: playerType,
                numberOfPlayers: numberOfPlayers,
                aiDifficulty: aiDifficulty
            )
        }
    }
}

#Preview {
    ContentView()
        .environment(Audio())
}
