//
//  GameplayPage.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct GameplayPage: View {
    @State private var diceScale: CGFloat = 0.8
    @State private var showArrows = false
    
    var body: some View {
        VStack(spacing: 40) {
            Text("How to Play")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(ColorTheme.primaryText)
            
            VStack(spacing: 30) {
                // Interactive dice preview
                ZStack {
                    if showArrows {
                        ForEach(0..<4) { index in
                            ArrowIndicator(angle: Double(index) * 90)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    
                    InteractiveDicePreview()
                        .scaleEffect(diceScale)
                }
                .frame(height: 200)
                
                VStack(alignment: .leading, spacing: 20) {
                    FeatureRow(
                        icon: "hand.tap.fill",
                        title: "Tap to Claim",
                        description: "Touch any neutral dice to make it yours"
                    )
                    
                    FeatureRow(
                        icon: "plus.circle.fill",
                        title: "Build Strength",
                        description: "Each tap increases the dice value by one"
                    )
                    
                    FeatureRow(
                        icon: "burst.fill",
                        title: "Chain Reactions",
                        description: "Dice explode when value exceeds neighbors"
                    )
                }
                .padding(.horizontal, 30)
            }
            
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                diceScale = 1.2
            }
            
            withAnimation(.easeInOut(duration: 0.8).delay(0.5)) {
                showArrows = true
            }
        }
    }
}

#Preview {
    GameplayPage()
        .environment(Audio())
}
