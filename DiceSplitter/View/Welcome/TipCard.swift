//
//  TipCard.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/17/25.
//

import SwiftUI

struct TipCard: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(text)
                .font(.callout)
                .foregroundStyle(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(width: 280)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    TipCard(icon: "house", text: "Text", color: .green)
}
