//
//  SliderRow.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/17/25.
//


import SwiftUI

struct SliderRow: View {
    let label: String
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(label, systemImage: icon)
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundStyle(ColorTheme.secondaryText)
                
                Spacer()
                
                Text("\(Int(value))")
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .foregroundStyle(ColorTheme.primaryText)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3), value: value)
            }
            
            Slider(value: $value, in: range, step: 1.0)
                .tint(ColorTheme.primary)
        }
    }
}