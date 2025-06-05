//
//  InteractiveDicePreview.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct InteractiveDicePreview: View {
    @State private var dice = Dice(row: 0, column: 0, neighbors: 3)
    @State private var tapCount = 0

    var body: some View {
        VStack(spacing: 20) {
            DiceView(dice: dice)
                .frame(width: 100, height: 100)
                .onTapGesture {
                    withAnimation(.bouncy) {
                        if dice.owner == .none {
                            dice.owner = .green
                        }
                        dice.value = min(dice.value + 1, 6)
                        tapCount += 1
                        
                        if dice.value > 3 {
                            dice.value = 1
                        }
                    }
                }
            
            Text( tapCount > 0 ? "Tap the dice to claim it!" : "Value: \(dice.value)/\(dice.neighbors)")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
        }
    }
}

#Preview {
    InteractiveDicePreview()
}
