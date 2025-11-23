//
//  StrategyTip.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct StrategyTip: View {
    let number: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Text(number)
                .font(.system(.title, design: .rounded, weight: .black))
                .foregroundStyle(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundStyle(ColorTheme.primaryText)
                
                Text(description)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(ColorTheme.secondaryText)
            }
            
            Spacer()
        }
        .padding()
        .glassMorphism(cornerRadius: 16)
    }
}

#Preview {
    StrategyTip(number: "2", title: "Title", description: "I love this title", color: .red)
}

