//
//  PlayerScoreTicker.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

// MARK: - Enhanced Player Score Ticker
struct PlayerScoreTicker: View {
    let currentPlayer: Player
    let scores: [(player: Player, score: Int)]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(scores, id: \.player) { player, score in
                    PlayerBadge(
                        player: player,
                        score: score,
                        isActive: player == currentPlayer
                    )
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .scale(scale: 1.2).combined(with: .opacity)
                    ))
                }
            }
        }
    }
}

#Preview {
    PlayerScoreTicker(currentPlayer: .blue, scores: [(Player.blue, 10)])
}
