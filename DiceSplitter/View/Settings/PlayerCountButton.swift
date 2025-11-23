//
//  EnhancedPlayerCountButton.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI

struct PlayerCountButton: View {
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(ColorTheme.primary)
                            .blur(radius: 10)
                            .opacity(0.5)
                    }
                    
                    Circle()
                        .fill(isSelected ? ColorTheme.primary : Color.clear)
                        .overlay(
                            Circle()
                                .stroke(
                                    isSelected ? Color.clear : ColorTheme.primary.opacity(0.3),
                                    lineWidth: 2
                                )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: count == 4 ? "person.badge.plus" : "person.\(count)")
                                .font(.title2)
                                .foregroundStyle(isSelected ? .white : ColorTheme.primaryText)
                                .symbolVariant(isSelected ? .fill : .none)
                        )
                }
                
                Text("\(count)")
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .foregroundStyle(ColorTheme.primaryText)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
