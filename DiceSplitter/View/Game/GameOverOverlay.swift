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
    @State private var contentScale: CGFloat = 0.8
    @State private var contentOpacity: Double = 0
    
    let reset: () -> Void
    
    var body: some View {
        ZStack {
            // Animated backdrop
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .transition(.opacity)
                .onTapGesture { } // Prevent tap through
            
            // Victory effects for winner
            if let winner = winner {
                // Radial gradient background
                RadialGradient(
                    colors: [
                        winner.color.opacity(0.3),
                        winner.color.opacity(0.1),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 50,
                    endRadius: 300
                )
                .ignoresSafeArea()
                .blur(radius: 20)
                .opacity(showConfetti ? 1 : 0)
                .animation(.easeInOut(duration: 1), value: showConfetti)
            }
            
            // Confetti for winner
            if let winner = winner, showConfetti {
                ConfettiView(playerColor: winner.color)
                    .ignoresSafeArea()
            }
            
            // Main content card
            VStack(spacing: 32) {
                // Victory Crown for winner
                if winner != nil && showCrown {
                    VictoryCrownView()
                        .frame(height: 120)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.5).combined(with: .opacity),
                            removal: .scale(scale: 1.5).combined(with: .opacity)
                        ))
                }
                
                // Title
                VStack(spacing: 8) {
                    Text("Game Over")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [ColorTheme.primaryText, ColorTheme.primaryText.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    if winner != nil {
                        Text("Victory!")
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundStyle(ColorTheme.accent)
                            .shimmer()
                    }
                }
                
                // Winner/Draw Display
                if let winner {
                    VStack(spacing: 20) {
                        Text("Winner")
                            .font(.system(.headline, design: .rounded, weight: .medium))
                            .foregroundStyle(ColorTheme.secondaryText)
                        
                        ZStack {
                            // Multiple pulse rings
                            ForEach(0..<3) { index in
                                PulseRingView(color: winner.color)
                                    .animation(
                                        .easeOut(duration: 2)
                                        .repeatForever(autoreverses: false)
                                        .delay(Double(index) * 0.5),
                                        value: showConfetti
                                    )
                            }
                            
                            // Winner badge
                            VStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [winner.color, winner.color.opacity(0.7)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.5), lineWidth: 3)
                                    )
                                    .shadow(color: winner.color, radius: 20)
                                    .neonGlow(color: winner.color, intensity: 8)
                                
                                Text("\(winnerScore)")
                                    .font(.system(size: 48, weight: .black, design: .rounded))
                                    .foregroundStyle(ColorTheme.primaryText)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .frame(width: 200, height: 150)
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "equal.square.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [ColorTheme.warning, ColorTheme.accent],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .symbolEffect(.pulse)
                        
                        Text("It's a Draw!")
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .foregroundStyle(ColorTheme.primaryText)
                    }
                }
                
                // Action Buttons
                VStack(spacing: 16) {
                    // Play Again Button
                    Button(action: reset) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title3)
                            Text("Play Again")
                                .font(.system(.title3, design: .rounded, weight: .bold))
                        }
                        .foregroundStyle(.white)
                        .frame(width: 260)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [
                                    winner?.color ?? ColorTheme.primary,
                                    (winner?.color ?? ColorTheme.secondary).opacity(0.8)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(
                            color: (winner?.color ?? ColorTheme.primary).opacity(0.5),
                            radius: 15,
                            y: 5
                        )
                    }
                    .buttonStyle(ScalingButtonStyle())
                    
                    // Settings Button
                    Button {
                        isShowingSettings = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "gear")
                                .font(.title3)
                            Text("Settings")
                                .font(.system(.title3, design: .rounded, weight: .semibold))
                        }
                        .foregroundStyle(ColorTheme.primaryText)
                        .frame(width: 260)
                        .padding(.vertical, 18)
                        .glassMorphism(cornerRadius: 30)
                    }
                    .buttonStyle(ScalingButtonStyle())
                }
            }
            .padding(40)
            .glassMorphism(cornerRadius: 40)
            .overlay(
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                (winner?.color ?? ColorTheme.primary).opacity(0.5),
                                (winner?.color ?? ColorTheme.secondary).opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: ColorTheme.shadowColor, radius: 30)
            .padding()
            .scaleEffect(contentScale)
            .opacity(contentOpacity)
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
            // Stagger animations
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                contentScale = 1.0
                contentOpacity = 1.0
            }
            
            if winner != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showConfetti = true
                    showCrown = true
                }
            }
        }
    }
}

#Preview {
    GameOverOverlay(winner: .red, winnerScore: 20, mapSize: .constant(.zero), playerType: .constant(.human), numberOfPlayers: .constant(2), aiDifficulty: .constant(.medium), reset: {})
}
