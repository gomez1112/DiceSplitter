//
//  EnhancedAIThinkingIndicator.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI

// MARK: - Enhanced AI Thinking Indicator
struct AIThinkingIndicator: View {
    @State private var isAnimating = false
    @State private var rotation: Double = 0
    
    var body: some View {
        HStack(spacing: 10) {
            // Brain icon with rotation
            Image(systemName: "brain")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [ColorTheme.primary, ColorTheme.secondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .rotationEffect(.degrees(rotation))
                .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotation)
            
            // Animated dots
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(ColorTheme.primary)
                        .frame(width: 4, height: 4)
                        .opacity(isAnimating ? 1 : 0.3)
                        .animation(
                            .easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .glassMorphism(cornerRadius: 20)
        .neonGlow(color: ColorTheme.primary, intensity: 3)
        .onAppear {
            isAnimating = true
            rotation = 360
        }
    }
}

#Preview {
    AIThinkingIndicator()
}
