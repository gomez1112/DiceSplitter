//
//  ContentView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var game: Game?
    @State private var mapSize = CGSize(width: 6, height: 6)
    @State private var playerType: PlayerType = .ai
    @State private var numberOfPlayers = 3
    
    var body: some View {
        NavigationStack {
            if hasCompletedOnboarding {
                if let game {
                    ZStack {
                        GameView(game: game, mapSize: $mapSize, playerType: $playerType, numberOfPlayers: $numberOfPlayers, resetGame: {
                            self.game = Game(
                                rows: Int(mapSize.width),
                                columns: Int(mapSize.height),
                                playerType: playerType,
                                numberOfPlayers: numberOfPlayers)
                        })
                            .navigationTitle("Dice Splitter")
                            #if !os(macOS)
                            .navigationBarTitleDisplayMode(.inline)
                            #endif
                            .blur(radius: game.isGameOver ? 10 : 0)
                        if game.isGameOver {
                            GameOverOverlay(winner: game.winner, winnerScore: game.winner.map { game.score(for: $0)} ?? 0) {
                                self.game = Game(
                                    rows: Int(mapSize.width),
                                    columns: Int(mapSize.height),
                                    playerType: playerType,
                                    numberOfPlayers: numberOfPlayers
                                )
                            }
                            
                        }
                    }
                } else {
                    SettingsView(mapSize: $mapSize, playerType: $playerType, numberOfPlayers: $numberOfPlayers, startGame: startGame)
                    
                }
            } else {
                OnboardingView(mapSize: $mapSize, playerType: $playerType, numberOfPlayers: $numberOfPlayers) {
                    hasCompletedOnboarding = true
                    startGame()
                }
            }
        }
    }
    
    private func startGame() {
        game = Game(rows: Int(mapSize.width), columns: Int(mapSize.height), playerType: playerType, numberOfPlayers: numberOfPlayers)
    }
}

#Preview {
    ContentView()
}
