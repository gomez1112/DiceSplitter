//
//  GameView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftUI

struct GameView: View {
    let game: Game
    @State private var showingSettings = false
    @Binding var mapSize: CGSize
    @Binding var playerType: PlayerType
    @Binding var numberOfPlayers: Int
    let resetGame: () -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                MeshGradientView()
                    .opacity(0.1)
                ParticleView()
                    .blendMode(.plusLighter)
                VStack(spacing: 0) {
                    PlayerScoreTicker(currentPlayer: game.activePlayer, scores: game.players.map { ($0, game.score(for: $0)) })
                        .padding()
                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: game.rows.first?.count ?? 5), spacing: 8) {
                            ForEach(game.rows.flatMap { $0 }, id: \.id) { dice in
                                Button {
                                    game.increment(dice)
                                } label: {
                                    DiceView(dice: dice)
                                }
                            }
                        }
                        .padding()
                    }
                    .scrollIndicators(.hidden)
                    
                }
                .navigationTitle("Dice Splitter")
                #if !os(macOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button {
                                resetGame()
                            } label: {
                                Label("New Game", systemImage: "arrow.clockwise")
                            }
                            Button("Settings", systemImage: "gear") { showingSettings.toggle() }
                            
                        } label: {
                            Label("Menu", systemImage: "ellipsis.circle")
                        }
                    }
                }
                .sheet(isPresented: $showingSettings) {
                    SettingsView(
                        mapSize: $mapSize,
                        playerType: $playerType,
                        numberOfPlayers: $numberOfPlayers
                    ) {
                       resetGame()
                    }
                }
                .overlay {
                    if game.isGameOver {
                        GameOverOverlay(winner: game.winner, winnerScore: game.winner.map { game.score(for: $0)} ?? 0, mapSize: $mapSize, playerType: $playerType, numberOfPlayers: $numberOfPlayers, reset: resetGame)
                    }
                }
            }
        }
    }
}


#Preview {
    GameView(game: Game(rows: 4, columns: 4, playerType: .ai, numberOfPlayers: 3), mapSize: .constant(.zero), playerType: .constant(.ai), numberOfPlayers: .constant(3), resetGame: {})
}

