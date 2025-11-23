//
//  StrategyPage.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct StrategyPage: View {
    @State private var tipScale: CGFloat = 0.9
    @State private var tipOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Strategy Tips")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(ColorTheme.primaryText)
            
            VStack(spacing: 24) {
                StrategyTip(
                    number: "1",
                    title: "Control Corners",
                    description: "Corners have fewer neighbors, making them easier to defend",
                    color: ColorTheme.success
                )
                .scaleEffect(tipScale)
                .opacity(tipOpacity)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: tipOpacity)
                
                StrategyTip(
                    number: "2",
                    title: "Chain Reactions",
                    description: "Set up explosive combos to capture multiple tiles at once",
                    color: ColorTheme.warning
                )
                .scaleEffect(tipScale)
                .opacity(tipOpacity)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2), value: tipOpacity)
                
                StrategyTip(
                    number: "3",
                    title: "Block Opponents",
                    description: "Prevent enemies from building up strong positions",
                    color: ColorTheme.error
                )
                .scaleEffect(tipScale)
                .opacity(tipOpacity)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3), value: tipOpacity)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .onAppear {
            withAnimation {
                tipScale = 1
                tipOpacity = 1
            }
        }
    }
}

#Preview {
    StrategyPage()
}
