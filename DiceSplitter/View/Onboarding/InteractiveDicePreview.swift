//
//  InteractiveDicePreview.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct InteractiveDicePreview: View {
    @State private var dice = Dice(row: 0, column: 0, neighbors: 3)
    
    var body: some View {
        VStack(spacing: 20) {
            DiceView(dice: dice)
                .frame(width: 100, height: 100)
                .onTapGesture {
                    dice.owner = Player.green
                    dice.value += 1
                }
            
            Text("Tap the dice to claim it and increase its value!")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
        }
    }
}

#Preview {
    InteractiveDicePreview()
}
