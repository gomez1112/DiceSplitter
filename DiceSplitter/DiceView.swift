//
//  DiceView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftUI

struct DiceView: View {
    let dice: Dice
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(dice.owner.color.opacity(0.3))
                .shadow(color: dice.owner.color.opacity(0.5), radius: 5, x: 0, y: 5)
            diceImage
                .foregroundStyle(dice.owner.color)
                .overlay(
                    diceImage
                        .foregroundStyle(.white)
                        .opacity(dice.changeAmount)
                )
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(2)
    }
    
    var diceImage: some View {
        Image(systemName: "die.face.\(dice.value).fill")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding(10)
    }
}

#Preview {
    DiceView(dice: Dice(row: 8, column: 11, neighbors: 3))
}
