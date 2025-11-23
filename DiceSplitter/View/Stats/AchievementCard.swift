//
//  AchievementCard.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    @State private var isPressed = false
    @State private var showingDetails = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
            ZStack {
                if isUnlocked {
                    Circle()
                        .fill(ColorTheme.warning.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .blur(radius: 10)
                }
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 36))
                    .foregroundStyle(isUnlocked ? ColorTheme.warning : ColorTheme.tertiaryText)
                    .symbolEffect(.bounce, value: isUnlocked)
                    .scaleEffect(isPressed ? 0.9 : 1)
            }
            
            // Title
            Text(achievement.name)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(isUnlocked ? ColorTheme.primaryText : ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Description
            Text(achievement.description)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(ColorTheme.tertiaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Status
            if isUnlocked {
                Label("Unlocked", systemImage: "checkmark.circle.fill")
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundStyle(ColorTheme.success)
            } else {
                Text("Locked")
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundStyle(ColorTheme.tertiaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .padding()
        .background {
            if isUnlocked {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(ColorTheme.warning.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(ColorTheme.warning.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: ColorTheme.warning.opacity(0.2), radius: 10)
            } else {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(ColorTheme.tertiaryText.opacity(0.2), lineWidth: 1)
                    )
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
}

#Preview {
    AchievementCard(achievement: Achievement.allAchievements[0], isUnlocked: true)
}

#Preview {
    AchievementCard(achievement: Achievement.allAchievements[0], isUnlocked: false)
}
