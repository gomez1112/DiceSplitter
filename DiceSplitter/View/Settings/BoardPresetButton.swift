//
//  BoardPresetButton.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI

struct BoardPresetButton: View {
    let width: Int
    let height: Int
    let label: String
    let currentSize: CGSize
    let action: () -> Void
    
    var isSelected: Bool {
        Int(currentSize.width) == width && Int(currentSize.height) == height
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text("\(width)×\(height)")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                
                Text(label)
                    .font(.system(.caption, design: .rounded))
            }
            .foregroundStyle(isSelected ? .white : ColorTheme.primaryText)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(isSelected ? ColorTheme.primary : Color.clear)
                    .overlay(
                        Capsule()
                            .stroke(
                                isSelected ? Color.clear : ColorTheme.primary.opacity(0.3),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(ScalingButtonStyle())
    }
}
