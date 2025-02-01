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
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(dice.owner.color.opacity(0.2))
                .shadow(color: dice.owner.color.opacity(0.3), radius: 3, x: 0, y: 2)
            diceImage
                .foregroundStyle(dice.owner.color)
                .symbolEffect(.bounce, value: dice.value)
                .contentTransition(.numericText(value: Double(dice.value)))
                .overlay(
                    diceImage
                        .foregroundStyle(.white)
                        .opacity(dice.changeAmount)
                )
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(dice.value) dots, \(dice.owner.accessibilityName)")
        .accessibilityHint("Double tap to claim for \(dice.owner == .none ? "yourself" : "reinforce")")
        .overlay(alignment: .topTrailing) {
            if dice.owner != .none {
                ownershipBadge
            }
        }
    }
    
    var diceImage: some View {
        Image(systemName: "die.face.\(dice.value).fill")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding(10)
    }
    private var ownershipBadge: some View {
        Circle()
            .fill(dice.owner.color)
            .frame(width: 8, height: 8)
            .padding(4)
            .background(.thinMaterial, in: Circle())
            .offset(x: -4, y: 4)
    }
}


#Preview {
    DiceView(dice: Dice(row: 8, column: 11, neighbors: 3))
}
