//
//  ArrowIndicator.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct ArrowIndicator: View {
    let angle: Double
    @State private var opacity: Double = 0
    
    var body: some View {
        Image(systemName: "arrow.down")
            .font(.title)
            .foregroundStyle(ColorTheme.primary)
            .rotationEffect(.degrees(angle))
            .offset(
                x: cos(angle * .pi / 180) * 80,
                y: sin(angle * .pi / 180) * 80
            )
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    opacity = 1
                }
            }
    }
}

#Preview {
    ArrowIndicator(angle: 2.0)
}
