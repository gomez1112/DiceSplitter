//
//  FloatingDice.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/17/25.
//

import SwiftUI

struct FloatingDice: View {
    let number: Int
    let delay: Double
    let isActive: Bool
    let isSelected: Bool
    
    @State private var rotation = 0.0
    @State private var yOffset: CGFloat = 0
    @State private var scale: CGFloat = 0
    
    var body: some View {
        Label("Dice \(number)", systemImage: "die.face.\(number).fill")
            .labelStyle(.iconOnly)
            .font(.title3)
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.8),
                        Color.blue.opacity(0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .rotationEffect(.degrees(rotation))
            .offset(y: yOffset)
            .scaleEffect(scale)
            .opacity(isActive ? 0.8 : 0)
            .blur(radius: 1)
            .shadow(color: .blue.opacity(0.5), radius: 10)
            .scaleEffect(isSelected ? 1.2 : 1)
            .overlay {
                if isSelected {
                    Circle()
                        .stroke(.white.opacity(0.6), lineWidth: 1)
                        .scaleEffect(1.6)
                        .opacity(0.8)
                        .transition(.opacity)
                }
            }
            .onChange(of: isActive, initial: true) { _, newValue in
                guard newValue else { return }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(delay)) {
                    scale = 1
                }

                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true).delay(delay)) {
                    yOffset = -20
                }

                withAnimation(.linear(duration: 10).repeatForever(autoreverses: false).delay(delay)) {
                    rotation = 360
                }
            }
    }
}

#Preview {
    FloatingDice(number: 2, delay: 0.3, isActive: true, isSelected: true)
}
