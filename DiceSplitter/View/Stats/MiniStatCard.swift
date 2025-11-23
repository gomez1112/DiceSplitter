//
//  MiniStatCard.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct MiniStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
            
            Text(value)
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundStyle(ColorTheme.primaryText)
                .contentTransition(.numericText())
            
            Text(title)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .glassMorphism(cornerRadius: 20)
        .onAppear {
            if color != ColorTheme.tertiaryText {
                isAnimating = true
            }
        }
    }
}

#Preview {
    MiniStatCard(title: "Title", value: "20", icon: "house", color: .green)
}
