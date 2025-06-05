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
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(piece.color)
            .frame(width: piece.size, height: piece.size * 0.6)
            .position(x: piece.startX + xOffset, y: piece.startY + yPosition)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: piece.duration)) {
                    yPosition = piece.endY
                    xOffset = CGFloat.random(in: -50...50)
                }
                
                withAnimation(.linear(duration: piece.duration).repeatForever(autoreverses: false)) {
                    rotation = piece.rotation + 360
                }
            }
    }
}

#Preview {
    ConfettiPieceView(piece: ConfettiPiece(color: .green, size: 20, startX: 10, startY: 10, endY: 10, rotation: 10, duration: 10))
}
