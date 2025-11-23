//
//  RecordRow.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct RecordRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(color)
            }
            
            Text(label)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(ColorTheme.secondaryText)
            
            Spacer()
            
            Text(value)
                .font(.system(.body, design: .rounded, weight: .bold))
                .foregroundStyle(ColorTheme.primaryText)
        }
    }
}

#Preview {
    RecordRow(icon: "house", label: "Label", value: "20", color: .red)
}
