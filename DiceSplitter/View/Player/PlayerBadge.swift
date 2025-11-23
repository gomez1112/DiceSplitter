//
//  PlayerBadge.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

// MARK: - Enhanced Player Badge
struct PlayerBadge: View {
    let player: Player
    let score: Int
    let isActive: Bool
    
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 10) {
            // Player icon with glow
            ZStack {
                if isActive {
                    Circle()
                        .fill(player.color)
                        .frame(width: 32, height: 32)
                        .blur(radius: 8)
                        .opacity(isAnimating ? 0.6 : 0.3)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                }
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [player.color, player.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Score with animation
            Text("\(score)")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(ColorTheme.primaryText)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: score)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background {
            if isActive {
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .fill(player.color.opacity(0.2))
                    )
                    .overlay(
                        Capsule()
                            .stroke(player.color, lineWidth: 2)
                    )
                    .shadow(color: player.color.opacity(0.5), radius: 8)
            } else {
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            }
        }
        .scaleEffect(isActive ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isActive)
        .onAppear {
            if isActive {
                isAnimating = true
            }
        }
        .onChange(of: isActive) { _, newValue in
            isAnimating = newValue
        }
    }
}

#Preview {
    PlayerBadge(player: .green, score: 10, isActive: true)
}
