//
//  GameOverOverlay.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct GameOverOverlay: View {
    let winner: Player?
    let winnerScore: Int
    @Binding var mapSize: CGSize
    @Binding var playerType: PlayerType
    @Binding var numberOfPlayers: Int
    @Binding var aiDifficulty: AIDifficulty
    
    @State private var isShowingSettings = false
    @State private var showConfetti = false
    @State private var showCrown = false
    
    let reset: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .transition(.opacity)
            
            // Confetti for winner
            if let winner = winner, showConfetti {
                ConfettiView(playerColor: winner.color)
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 24) {
                // Victory Crown for winner
                if winner != nil && showCrown {
                    VictoryCrownView()
                        .frame(height: 100)
                }
                
                Text("Game Over")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(.primary)
                
                if let winner {
                    VStack(spacing: 12) {
                        Text("Winner")
                            .font(.system(.title3, design: .rounded, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        ZStack {
                            // Pulse rings
                            ForEach(0..<3) { index in
                                PulseRingView(color: winner.color)
                                    .animation(.easeOut(duration: 1.5).repeatForever(autoreverses: false).delay(Double(index) * 0.5), value: showConfetti)
                            }
                            
                            PlayerChip(player: winner, score: winnerScore, isActive: true)
                                .scaleEffect(1.3)
                        }
                        .frame(width: 150, height: 80)
                    }
                } else {
                    Text("It's a Draw!")
                        .font(.system(.title, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                
                HStack(spacing: 16) {
                    Button(action: reset) {
                        Label("Play Again", systemImage: "arrow.clockwise")
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .frame(minWidth: 140)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(winner?.color ?? .blue)
                    
                    Button {
                        isShowingSettings = true
                    } label: {
                        Label("Settings", systemImage: "gear")
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .frame(minWidth: 140)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .tint(.blue)
                }
            }
            .padding(32)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(radius: 20)
            .padding()
            .transition(.scale(scale: 0.8).combined(with: .opacity))
            .sheet(isPresented: $isShowingSettings) {
                SettingsView(
                    mapSize: $mapSize,
                    playerType: $playerType,
                    numberOfPlayers: $numberOfPlayers,
                    aiDifficulty: $aiDifficulty,
                    showingWarning: false
                ) {
                    isShowingSettings = false
                    reset()
                }
            }
        }
        .onAppear {
            if winner != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showConfetti = true
                    showCrown = true
                }
            }
        }
        .animation(.spring(duration: 0.5, bounce: 0.7), value: winner)
    }
}
