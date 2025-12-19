//
//  ConfettiAnimation.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/17/25.
//

import SwiftUI

struct ConfettiAnimation: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(confettiPieces) { piece in
                    ConfettiPieceView(piece: piece)
                }
            }
            .task(id: geometry.size) {
                createConfetti(in: geometry)
                try? await Task.sleep(for: .seconds(6))
                confettiPieces.removeAll()
            }
        }
    }
    @MainActor
    private func createConfetti(in geometry: GeometryProxy) {
        for index in 0..<100 {
            let shape = [ConfettiPiece.Shape.circle, .rectangle].randomElement() ?? .circle
            let color = [.blue, .purple, .pink, .yellow, .green, .orange].randomElement() ?? .blue
            let piece = ConfettiPiece(
                shape: shape,
                color: color,
                size: CGFloat.random(in: 8...16),
                startX: CGFloat.random(in: 0...geometry.size.width),
                startY: -20,
                endY: geometry.size.height + 50,
                horizontalMovement: CGFloat.random(in: -100...100),
                rotation: Double.random(in: 0...360),
                duration: Double.random(in: 2...4),
                delay: Double(index) * 0.01
            )
            confettiPieces.append(piece)
        }
    }
}

#Preview {
    ConfettiAnimation()
}
