//
//  EnhancedAchievementNotification.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI

// MARK: - Enhanced Achievement Notification
struct AchievementNotification: View {
    let achievement: Achievement
    @State private var isShowing = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with glow
            ZStack {
                Image(systemName: achievement.icon)
                    .font(.largeTitle)
                    .foregroundStyle(.yellow)
                    .symbolEffect(.bounce, value: isShowing)
                    .neonGlow(color: .yellow, intensity: 4)
            }
            .frame(width: 60)
            
            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text("Achievement Unlocked!")
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(ColorTheme.secondaryText)
                
                Text(achievement.name)
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(ColorTheme.primaryText)
                
                Text(achievement.description)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(ColorTheme.tertiaryText)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(20)
        .glassMorphism(cornerRadius: 20)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [.yellow.opacity(0.5), .orange.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: .yellow.opacity(0.3), radius: 20)
        .padding(.horizontal)
        .scaleEffect(isShowing ? 1 : 0.8)
        .opacity(isShowing ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                isShowing = true
            }
        }
    }
}
