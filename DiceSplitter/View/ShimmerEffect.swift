//
//  ShimmerEffect.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI

// MARK: - Shimmer Effect
struct ShimmerEffect: ViewModifier {
    @State private var isAnimating = false
    let duration: Double
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.3),
                            Color.white.opacity(0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.3)
                    .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                    .animation(
                        Animation.linear(duration: duration)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
                }
                .mask(content)
            )
            .onAppear {
                isAnimating = true
            }
    }
}
