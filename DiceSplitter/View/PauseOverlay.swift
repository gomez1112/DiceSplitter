//
//  EnhancedPauseOverlay.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI

// MARK: - Enhanced Pause Overlay
struct PauseOverlay: View {
    let game: Game
    let resumeAction: () -> Void
    
    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .transition(.opacity)
            
            // Content
            VStack(spacing: 32) {
                // Title
                VStack(spacing: 8) {
                    Image(systemName: "pause.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [ColorTheme.primary, ColorTheme.secondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .symbolEffect(.pulse)
                    
                    Text("Game Paused")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(ColorTheme.primaryText)
                }
                
                // Game Stats
                VStack(spacing: 20) {
                    GameStatCard(
                        icon: "timer",
                        label: "Time",
                        value: formatTime(game.gameDuration),
                        color: ColorTheme.info
                    )
                    
                    GameStatCard(
                        icon: "hand.tap.fill",
                        label: "Moves",
                        value: "\(game.totalMoves)",
                        color: ColorTheme.warning
                    )
                }
                
                // Resume Button
                Button(action: resumeAction) {
                    HStack(spacing: 12) {
                        Image(systemName: "play.fill")
                            .font(.title3)
                        Text("Resume Game")
                            .font(.system(.title3, design: .rounded, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(width: 250)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [ColorTheme.primary, ColorTheme.secondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: ColorTheme.primary.opacity(0.5), radius: 10, y: 5)
                }
                .buttonStyle(ScalingButtonStyle())
            }
            .padding(40)
            .glassMorphism(cornerRadius: 30)
            .shadow(color: ColorTheme.shadowColor, radius: 30)
            .padding()
            .transition(.scale(scale: 0.9).combined(with: .opacity))
        }
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    PauseOverlay(game: Game.init(rows: 3, columns: 3, playerType: .human, numberOfPlayers: 2), resumeAction: {})
}
