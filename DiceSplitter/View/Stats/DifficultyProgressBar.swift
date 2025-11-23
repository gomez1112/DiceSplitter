//
//  DifficultyProgressBar.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct DifficultyProgressBar: View {
    let difficulty: String
    let wins: Int
    let total: Int
    let color: Color
    
    var progress: Double {
        guard total > 0 else { return 0 }
        return Double(wins) / Double(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(difficulty)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(ColorTheme.primaryText)
                
                Spacer()
                
                Text("\(wins)")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(color)
                    .contentTransition(.numericText())
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progress)
                    
                    if progress > 0 {
                        Circle()
                            .fill(color)
                            .frame(width: 12, height: 12)
                            .offset(x: geometry.size.width * progress - 6)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progress)
                    }
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    DifficultyProgressBar(difficulty: "Hard", wins: 5, total: 10, color: .green)
}
