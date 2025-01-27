//
//  GameView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftUI

struct GameView: View {
    let game: Game
    var body: some View {
        VStack(spacing: 5) {
            Text("Dice Splitter")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 10)
            HStack(spacing: 20) {
                ForEach(game.players, id: \.self) { player in
                    Text("\(player.displayName): \(game.score(for: player))")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundStyle(player.color)
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
            }
            .padding(.vertical, 10)
            
            ForEach(game.rows.indices, id: \.self) { row in
                HStack(spacing: 5) {
                    ForEach(game.rows[row]) { dice in
                        DiceView(dice: dice)
                            .onTapGesture {
                                game.increment(dice)
                            }
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    GameView(game: Game(rows: 5, columns: 5, playerType: .human, numberOfPlayers: 3))
}

