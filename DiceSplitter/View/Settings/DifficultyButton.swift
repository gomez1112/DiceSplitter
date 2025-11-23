//
//  DifficultyButton.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI

struct DifficultyButton: View {
    let difficulty: AIDifficulty
    let isSelected: Bool
    let action: () -> Void
    
    var difficultyColor: Color {
        switch difficulty {
        case .easy: return ColorTheme.success
        case .medium: return ColorTheme.warning
        case .hard: return ColorTheme.accent
        case .expert: return ColorTheme.error
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(difficulty.rawValue)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(isSelected ? .white : ColorTheme.primaryText)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? difficultyColor : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isSelected ? Color.clear : difficultyColor.opacity(0.5),
                                    lineWidth: 1.5
                                )
                        )
                )
                .minimumScaleFactor(0.1)
        }
        .buttonStyle(ScalingButtonStyle())
    }
}

#Preview {
    DifficultyButton(difficulty: .expert, isSelected: true, action: {})
}
