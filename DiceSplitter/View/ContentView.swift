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
    @AppStorage("playerName") private var playerName = ""
    
    @State private var selectedTab = Tabs.play
    @State private var isShowingWelcomeScreen = false
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
        TabView(selection: $selectedTab) {
            Tab(value: .play) {
                    if let game = game {
                        GameView(
                            game: game,
                            mapSize: $mapSize,
                            playerType: $playerType,
                            numberOfPlayers: $numberOfPlayers,
                            aiDifficulty: $aiDifficulty,
                            resetGame: resetGame,
                            stats: stat
                        )
                    } else if !hasCompletedOnboarding {
                        OnboardingView(
                            playerName: $playerName,
                            mapSize: $mapSize,
                            playerType: $playerType,
                            numberOfPlayers: $numberOfPlayers,
                            aiDifficulty: $aiDifficulty
                        ) {
                            hasCompletedOnboarding = true
                            withAnimation {
                                isShowingWelcomeScreen = true
                            }
                        }
                    } else if isShowingWelcomeScreen || game == nil {
                        WelcomeScreen(
                            showWelcome: $isShowingWelcomeScreen,
                            playerName: playerName
                        ) {
                            startGame()
                        }
                    }
            } label: {
                Tabs.play.tabLabel
            }
            Tab(value: Tabs.stats) {
                StatisticsView(stats: stat)
            } label: {
                Tabs.stats.tabLabel
            }
            Tab(value: Tabs.settings) {
                SettingsView(
                    mapSize: $mapSize,
                    playerType: $playerType,
                    numberOfPlayers: $numberOfPlayers,
                    aiDifficulty: $aiDifficulty,
                    showingWarning: game != nil && !(game?.isGameOver ?? true),
                    startGame: {
                        selectedTab = .play
                        resetGame()
                    }
                )
            } label: {
                Tabs.settings.tabLabel
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
    private func resetGame() {
        game = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            startGame()
        }
    }
}

#Preview {
    ContentView()
        .environment(Audio())
}
