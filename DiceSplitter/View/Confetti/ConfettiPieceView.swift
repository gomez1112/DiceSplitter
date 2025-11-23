//
//  ConfettiPieceView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 6/5/25.
//

import SwiftUI

struct ConfettiPieceView: View {
    let piece: ConfettiPiece
    @State private var yPosition: CGFloat = 0
    @State private var xOffset: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1
    
    var body: some View {
        Group {
            switch piece.shape {
                case .circle:
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [piece.color, piece.color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: piece.size, height: piece.size)
                case .rectangle:
                    RoundedRectangle(cornerRadius: piece.size * 0.2)
                        .fill(
                            LinearGradient(
                                colors: [piece.color, piece.color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: piece.size, height: piece.size * 0.6)
            }
        }
        .position(x: piece.startX + xOffset, y: piece.startY + yPosition)
        .rotationEffect(.degrees(rotation))
        .opacity(opacity)
        .blur(radius: opacity < 0.5 ? 1 : 0)
        .onAppear {
            withAnimation(.linear(duration: piece.duration).delay(piece.delay)) {
                yPosition = piece.endY
                xOffset = piece.horizontalMovement
                opacity = 0.3
            }
            
            withAnimation(.linear(duration: piece.duration).repeatForever(autoreverses: false).delay(piece.delay)) {
                rotation = piece.rotation + 360
            }
        }
    }
}

#Preview {
    ConfettiPieceView(piece: ConfettiPiece(shape: .circle, color: .green, size: 0.3, startX: 20, startY: 10, endY: 10, horizontalMovement: 5.0, rotation: 10, duration: 10, delay: 10))
}
