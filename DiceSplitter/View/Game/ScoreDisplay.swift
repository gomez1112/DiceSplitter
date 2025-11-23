//
//  ScoreDisplay.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/17/25.
//

import SwiftUI

struct ScoreDisplay: View {
    let players: [Player]
    let scores: [Int]
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(Array(zip(players, scores)), id: \.0) { player, score in
                HStack(spacing: 4) {
                    Circle()
                        .fill(player.color)
                        .frame(width: 16, height: 16)
                    Text("\(score)")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                }
            }
        }
    }
}
