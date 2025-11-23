//
//  CurrentPlayerIndicator.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/17/25.
//

import SwiftUI

struct CurrentPlayerIndicator: View {
    let player: Player
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(player.color)
                .frame(width: 20, height: 20)
                .overlay(
                    Circle()
                        .strokeBorder(Color.white.opacity(0.5), lineWidth: 2)
                )
            
            Text("\(player.displayName)'s Turn")
                .font(.subheadline.bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.1))
        .clipShape(Capsule())
    }
}
