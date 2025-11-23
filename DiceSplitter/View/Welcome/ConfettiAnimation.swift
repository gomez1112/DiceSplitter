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
            .onAppear {
                createConfetti(in: geometry)
                DispatchQueue.main.asyncAfter(deadline: .now() + 6) { confettiPieces.removeAll() }
            }
        }
    }
    private func createConfetti(in geometry: GeometryProxy) {
        for index in 0..<100 {
            let piece = ConfettiPiece(shape: [ConfettiPiece.Shape.circle, .rectangle].randomElement()!, color: [.blue, .purple, .pink, .yellow, .green, .orange].randomElement()!, size: CGFloat.random(in: 8...16), startX: CGFloat.random(in: 0...geometry.size.width), startY: -20, endY: geometry.size.height + 50, horizontalMovement: CGFloat.random(in: -100...100), rotation: Double.random(in: 0...360), duration: Double.random(in: 2...4), delay: Double(index) * 0.01)
            confettiPieces.append(piece)
        }
    }
}

#Preview {
    ConfettiAnimation()
}
