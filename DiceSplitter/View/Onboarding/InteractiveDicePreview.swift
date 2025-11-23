//
//  InteractiveDicePreview.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

// Enhanced Interactive Preview for Onboarding
struct InteractiveDicePreview: View {
    @State private var dice = Dice(row: 0, column: 0, neighbors: 3)
    @State private var tapCount = 0
    @State private var showHint = true
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                // Background glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [ColorTheme.primary.opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 50,
                            endRadius: 100
                        )
                    )
                    .blur(radius: 10)
                    .scaleEffect(1.5)
                
                DiceView(dice: dice)
                    .frame(width: 120, height: 120)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            if dice.owner == .none {
                                dice.owner = .green
                                showHint = false
                            }
                            dice.value = min(dice.value + 1, 6)
                            tapCount += 1
                            
                            if dice.value > 3 {
                                dice.value = 1
                            }
                        }
                    }
            }
            
            if showHint {
                HStack(spacing: 8) {
                    Image(systemName: "hand.tap.fill")
                        .font(.title3)
                    Text("Tap to claim!")
                        .font(.system(.body, design: .rounded, weight: .medium))
                }
                .foregroundColor(ColorTheme.primaryText)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .glassMorphism(cornerRadius: 25)
                .shimmer()
                .transition(.scale.combined(with: .opacity))
            } else {
                Text("Value: \(dice.value)/\(dice.neighbors)")
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

#Preview {
    InteractiveDicePreview()
        .environment(Audio())
}
