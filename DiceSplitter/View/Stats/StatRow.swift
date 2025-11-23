//
//  StatRow.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    let progress: Double
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.body)
                        .foregroundStyle(color)
                    
                    Text(label)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                Text(value)
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(ColorTheme.primaryText)
                    .contentTransition(.numericText())
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 6)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progress)
                }
            }
            .frame(height: 6)
        }
    }
}

#Preview {
    StatRow(icon: "house", label: "Label", value: "20", color: .green, progress: 0.80)
}
