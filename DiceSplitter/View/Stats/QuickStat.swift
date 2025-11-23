//
//  QuickStat.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct QuickStat: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(color)
                .contentTransition(.numericText())
            
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(ColorTheme.secondaryText)
        }
    }
}

#Preview {
    QuickStat(value: "Value", label: "Label", color: .green)
}
