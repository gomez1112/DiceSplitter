//
//  WinningPage.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct WinningPage: View {
    @State private var trophyScale: CGFloat = 0.5
    @State private var trophyRotation: Double = -45
    
    var body: some View {
        VStack(spacing: 40) {
            // Animated trophy
            Image(systemName: "trophy.fill")
                .font(.system(size: 120))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .scaleEffect(trophyScale)
                .rotationEffect(.degrees(trophyRotation))
                .neonGlow(color: .yellow, intensity: 10)
                .shadow(color: .yellow.opacity(0.5), radius: 30)
            
            VStack(spacing: 20) {
                Text("Win the Game")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(ColorTheme.primaryText)
                
                Text("Dominate the board or score the highest when no moves remain")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                WinCondition(
                    icon: "flag.fill",
                    text: "Control all dice on the board"
                )
                
                WinCondition(
                    icon: "chart.bar.fill",
                    text: "Have the highest score when game ends"
                )
                
                WinCondition(
                    icon: "brain",
                    text: "Outsmart your opponents with strategy"
                )
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                trophyScale = 1
                trophyRotation = 0
            }
        }
    }
}

#Preview {
    WinningPage()
}
