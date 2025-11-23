//
//  GameStatCard.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/17/25.
//


import SwiftUI
// MARK: - Game Stat Card
struct GameStatCard: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            // Icon
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 40)
            
            // Label
            Text(label)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(ColorTheme.secondaryText)
            
            Spacer()
            
            // Value
            Text(value)
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(ColorTheme.primaryText)
                .monospacedDigit()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    GameStatCard(icon: "trophy.fill", label: "Label", value: "20", color: .red)
}
