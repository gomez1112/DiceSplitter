//
//  VictoryCrownView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 6/5/25.
//

import SwiftUI

// MARK: - Enhanced Victory Crown
struct VictoryCrownView: View {
    @State private var scale: CGFloat = 0.1
    @State private var rotation: Double = -180
    @State private var sparkleOpacity: Double = 0
    @State private var sparkleScale: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            // Crown with gradient
            Image(systemName: "crown.fill")
                .font(.system(size: 100))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .shadow(color: .yellow.opacity(0.5), radius: 20)
                .neonGlow(color: .yellow, intensity: 10)
            
            // Animated sparkles
            ForEach(0..<12) { index in
                Image(systemName: "sparkle")
                    .font(.title)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .yellow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(sparkleOpacity)
                    .scaleEffect(sparkleScale)
                    .offset(
                        x: cos(Double(index) * .pi / 6) * 70,
                        y: sin(Double(index) * .pi / 6) * 70
                    )
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
            }
        }
        .onAppear {
            // Crown animation
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                rotation = 0
            }
            
            // Sparkle animation
            withAnimation(.easeInOut(duration: 0.8).delay(0.4)) {
                sparkleOpacity = 1.0
                sparkleScale = 1.0
            }
            
            // Continuous sparkle pulse
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(1.2)) {
                sparkleScale = 1.2
                sparkleOpacity = 0.7
            }
        }
    }
}

#Preview {
    VictoryCrownView()
}
