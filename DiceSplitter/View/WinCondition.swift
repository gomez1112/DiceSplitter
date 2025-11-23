//
//  WinCondition.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct WinCondition: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(ColorTheme.warning)
            
            Text(text)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(ColorTheme.primaryText)
            
            Spacer()
        }
    }
}

#Preview {
  WinCondition(icon: "exclamationmark.triangle", text: "You win!")
}
