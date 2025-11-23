//
//  PulseRingView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 6/5/25.
//

import SwiftUI

// MARK: - Enhanced Pulse Ring
struct PulseRingView: View {
    let color: Color
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 1.0
    
    var body: some View {
        Circle()
            .stroke(
                LinearGradient(
                    colors: [color, color.opacity(0.5)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 3
            )
            .scaleEffect(scale)
            .opacity(opacity)
            .blur(radius: opacity < 0.5 ? 2 : 0)
            .onAppear {
                withAnimation(.easeOut(duration: 2).repeatForever(autoreverses: false)) {
                    scale = 2.5
                    opacity = 0
                }
            }
    }
}

#Preview {
    PulseRingView(color: .green)
}
