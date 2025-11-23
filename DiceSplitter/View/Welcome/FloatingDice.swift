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
    
    @State private var rotation = 0.0
    @State private var yOffset: CGFloat = 0
    @State private var scale: CGFloat = 0
    
    var body: some View {
        Image(systemName: "die.face.\(number).fill")
            .font(.system(size: 20))
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
            .onAppear {
                if isActive {
                    // Entrance animation
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(delay)) {
                        scale = 1
                    }
                    
                    // Floating animation
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true).delay(delay)) {
                        yOffset = -20
                    }
                    
                    // Rotation animation
                    withAnimation(.linear(duration: 10).repeatForever(autoreverses: false).delay(delay)) {
                        rotation = 360
                    }
                }
            }
    }
}

#Preview {
    FloatingDice(number: 2, delay: 0.3, isActive: true)
}
