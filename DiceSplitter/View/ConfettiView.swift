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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(confettiPieces) { piece in
                    ConfettiPieceView(piece: piece)
                }
            }
            .onAppear {
                createConfetti(in: geometry.size)
            }
        }
        .allowsHitTesting(false)
    }
    
    private func createConfetti(in size: CGSize) {
        for i in 0..<50 {
            let delay = Double(i) * 0.02
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let piece = ConfettiPiece(
                    color: [playerColor, .yellow, .orange, .pink, .purple].randomElement()!,
                    size: CGFloat.random(in: 8...16),
                    startX: CGFloat.random(in: 0...size.width),
                    startY: -20,
                    endY: size.height + 50,
                    rotation: Double.random(in: 0...360),
                    duration: Double.random(in: 2...4)
                )
                confettiPieces.append(piece)
            }
        }
        
        // Clean up after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            confettiPieces.removeAll()
        }
    }
}

#Preview {
    ConfettiView(playerColor: .green)
}
