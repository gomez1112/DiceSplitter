//
//  GameTimer.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI

// MARK: - Game Timer
struct GameTimer: View {
    let duration: TimeInterval
    
    var formattedTime: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "timer")
                .font(.system(.caption, design: .rounded))
                .symbolRenderingMode(.hierarchical)
            
            Text(formattedTime)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .monospacedDigit()
        }
        .foregroundStyle(ColorTheme.secondaryText)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .glassMorphism(cornerRadius: 12)
    }
}
