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
                
                Button(action: reset) {
                    Label("Play Again", systemImage: "arrow.clockwise")
                        .font(.system(.body, design: .rounded, weight: .semibold))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .frame(minWidth: 160)
                }
                .buttonStyle(.borderedProminent)
                .tint(winner?.color ?? .blue)
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
struct PlayerChip: View {
    let player: Player
    let score: Int
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(player.color)
                .frame(width: 16, height: 16)
            
            Text("\(score)")
                .font(.system(.body, design: .rounded, weight: .bold))
                .contentTransition(.numericText())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            if isActive {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(player.color.opacity(0.2))
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(player.color.opacity(0.3), lineWidth: 1)
        }
        .animation(.bouncy, value: isActive)
    }
}
