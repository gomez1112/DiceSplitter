//
//  ConfettiView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 6/5/25.
//

import SwiftUI

struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    let playerColor: Color
    
    let confettiColors: [Color] = [
        .yellow, .orange, .pink, .purple, .blue, .green, .red
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(confettiPieces) { piece in
                    ConfettiPieceView(piece: piece)
                }
            }
            .task(id: geometry.size) {
                await createConfetti(in: geometry.size)
            }
        }
        .allowsHitTesting(false)
    }
    
    @MainActor
    private func createConfetti(in size: CGSize) async {
        for i in 0..<80 {
            let delay = Double(i) * 0.01
            try? await Task.sleep(for: .seconds(delay))
            let shape: ConfettiPiece.Shape = Bool.random() ? .circle : .rectangle
            let color = ([playerColor] + confettiColors).randomElement() ?? playerColor
            let piece = ConfettiPiece(
                shape: shape,
                color: color,
                size: CGFloat.random(in: 8...20),
                startX: CGFloat.random(in: 0...size.width),
                startY: -20,
                endY: size.height + 50,
                horizontalMovement: CGFloat.random(in: -100...100),
                rotation: Double.random(in: 0...360),
                duration: Double.random(in: 2...4),
                delay: delay
            )
            confettiPieces.append(piece)
        }

        try? await Task.sleep(for: .seconds(6))
        confettiPieces.removeAll()
    }
}

#Preview {
    ConfettiView(playerColor: .green)
}
