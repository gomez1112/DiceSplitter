//
//  DiceButtonStyle.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI

// MARK: - Button Styles
struct DiceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct GameControlButtonStyle: ButtonStyle {
    let isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isEnabled ? ColorTheme.primaryText : ColorTheme.tertiaryText)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .fill(isEnabled ? ColorTheme.primary.opacity(0.2) : Color.clear)
                    )
                    .overlay(
                        Capsule()
                            .stroke(
                                isEnabled ? ColorTheme.primary.opacity(0.5) : ColorTheme.tertiaryText.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            )
            .scaleEffect(configuration.isPressed && isEnabled ? 0.95 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct ScalingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
