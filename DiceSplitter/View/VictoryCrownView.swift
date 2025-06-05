//
//  VictoryCrownView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 6/5/25.
//

import SwiftUI

struct VictoryCrownView: View {
    @State private var scale: CGFloat = 0.1
    @State private var rotation: Double = -180
    @State private var sparkleOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Crown
            Image(systemName: "crown.fill")
                .font(.system(size: 80))
                .foregroundStyle(.yellow)
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .shadow(color: .yellow.opacity(0.5), radius: 20)
            
            // Sparkles
            ForEach(0..<8) { index in
                Image(systemName: "sparkle")
                    .font(.title)
                    .foregroundStyle(.white)
                    .opacity(sparkleOpacity)
                    .offset(
                        x: cos(Double(index) * .pi / 4) * 60,
                        y: sin(Double(index) * .pi / 4) * 60
                    )
                    .scaleEffect(sparkleOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                scale = 1.0
                rotation = 0
            }
            
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                sparkleOpacity = 1.0
            }
        }
    }
}

#Preview {
    VictoryCrownView()
}
