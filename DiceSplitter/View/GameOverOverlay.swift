//
//  GameOverOverlay.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

// MARK: - Game Over Overlay
struct GameOverOverlay: View {
    let winner: Player?
    let winnerScore: Int
    let reset: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .transition(.opacity)
            
            VStack(spacing: 20) {
                Text("Game Over")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(.primary)
                
                if let winner {
                    VStack(spacing: 8) {
                        Text("Winner")
                            .font(.system(.title3, design: .rounded, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        PlayerChip(player: winner, score: winnerScore, isActive: true)
                            .scaleEffect(1.2)
                    }
                } else {
                    Text("It's a Draw!")
                        .font(.system(.title, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Button(action: reset) {
                        Label("Play Again", systemImage: "arrow.clockwise")
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .frame(minWidth: 160)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(winner?.color ?? .blue)
                    NavigationLink {
                        ContentView()
                    } label: {
                        Label("Settings", systemImage: "gear")
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .frame(minWidth: 160)
                            .foregroundStyle(.white)
                            
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding()
            .transition(.scale.combined(with: .opacity))
        }
        .animation(.spring(duration: 0.5, bounce: 0.7), value: winner)
    }
}

#Preview {
    GameOverOverlay(winner: Player.green, winnerScore: 10, reset: {})
}
