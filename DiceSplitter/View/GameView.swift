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

    var body: some View {
        @Bindable var game = game
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
                                DiceView(dice: dice)
                                    .onTapGesture { game.increment(dice) }
                            }
                        }
                        .padding()
                    }
                    .scrollIndicators(.hidden)
                    
                }
                .scrollContentBackground(.visible)
                .navigationTitle("Dice Splitter")
                #if !os(macOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button {
                                game.reset(rows: Int(mapSize.width), columns: Int(mapSize.height), playerType: playerType, numberOfPlayers: numberOfPlayers)
                            } label: {
                                Label("New Game", systemImage: "arrow.circlepath")
                            }
                            Button("Reset Game") {
                                game.reset(rows: Int(mapSize.width), columns: Int(mapSize.height), playerType: playerType, numberOfPlayers: numberOfPlayers)
                            }
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            Button("Settings", systemImage: "gear", action: { showingSettings.toggle() })
                            
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
                        game.reset(
                            rows: Int(mapSize.width),
                            columns: Int(mapSize.height),
                            playerType: playerType,
                            numberOfPlayers: numberOfPlayers
                        )
                    }
                }
                .overlay {
                    if game.isGameOver {
                        GameOverOverlay(
                            winner: game.winner, winnerScore: game.winner.map { game.score(for: $0)} ?? 0,
                            reset: {
                                game.reset(
                                    rows: Int(mapSize.width),
                                    columns: Int(mapSize.height),
                                    playerType: playerType,
                                    numberOfPlayers: numberOfPlayers
                                )
                            }
                        )
                    }
                }
            }
        }
    }
}


#Preview {
    GameView(game: Game(rows: 4, columns: 4, playerType: .ai, numberOfPlayers: 3), mapSize: .constant(.zero), playerType: .constant(.ai), numberOfPlayers: .constant(3))
}

