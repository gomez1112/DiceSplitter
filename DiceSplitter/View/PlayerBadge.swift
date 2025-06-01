//
//  PlayerBadge.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct PlayerBadge: View {
    let player: Player
    let score: Int
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "person.fill")
                .foregroundColor(player.color)
            
            Text("\(score)")
                .font(.system(.body, design: .rounded, weight: .semibold))
                .contentTransition(.numericText())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background {
            if isActive {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(player.color.opacity(0.2))
            } else {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.regularMaterial)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(isActive ? player.color : Color.gray.opacity(0.3), lineWidth: 1)
        )
        .animation(.bouncy, value: isActive)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(player.accessibilityName), Score: \(score)")
    }
}

#Preview {
    PlayerBadge(player: .green, score: 10, isActive: true)
}
