//
//  PlayerCountButton.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct PlayerCountButton: View {
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: count == 4 ? "person.badge.plus" : "person.\(count)")
                    .font(.title2)
                    .symbolVariant(isSelected ? .fill : .none)
                    
                Text("\(count)")
                    .font(.callout.bold())
                    
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .blue.opacity(0.2) : .clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .blue : .gray.opacity(0.3), lineWidth: 2)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PlayerCountButton(count: 2, isSelected: true, action: {})
}
