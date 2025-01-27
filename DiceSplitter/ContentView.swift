//
//  ContentView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftUI

struct ContentView: View {
    @State private var game: Game?
    @State private var mapSize = CGSize(width: 5, height: 5)
    @State private var playerType: PlayerType = .ai
    @State private var numberOfplayers = 3
    
    var body: some View {
        NavigationStack {
            if let game {
                ZStack {
                    GameView(game: game)
                        .navigationTitle("Dice Splitter")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            Button("Reset Game", action: resetGame)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                        }
                        .blur(radius: game.isGameOver ? 10 : 0)
                    if game.isGameOver {
                        GameOverOverlay(winner: game.winner, reset: resetGame)
                            
                    }
                }
            } else {
                SettingsView(mapSize: $mapSize, playerType: $playerType, numberOfPlayers: $numberOfplayers, startGame: startGame)
            }
        }
    }
    
    private func resetGame() {
        game = nil
    }
    
    private func startGame() {
        game = Game(rows: Int(mapSize.width), columns: Int(mapSize.height), playerType: playerType, numberOfPlayers: numberOfplayers)
    }
}

#Preview {
    ContentView()
}
