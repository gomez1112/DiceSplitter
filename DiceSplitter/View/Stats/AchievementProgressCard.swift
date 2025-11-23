//
//  AchievementProgressCard.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct AchievementProgressCard: View {
    let unlockedCount: Int
    let totalCount: Int
    
    var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(unlockedCount) / Double(totalCount)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Achievement Progress")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(ColorTheme.primaryText)
                    
                    Text("\(unlockedCount) of \(totalCount) unlocked")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [ColorTheme.warning, ColorTheme.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: progress)
                    
                    Text("\(Int(progress * 100))%")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(ColorTheme.primaryText)
                }
                .frame(width: 80, height: 80)
            }
        }
        .padding(24)
        .glassMorphism(cornerRadius: 24)
    }
}

#Preview {
    AchievementProgressCard(unlockedCount: 2, totalCount: 6)
}
