//
//  FeatureRow.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(ColorTheme.primary)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundStyle(ColorTheme.primaryText)
                
                Text(description)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(ColorTheme.secondaryText)
            }
            
            Spacer()
        }
    }
}

#Preview {
    FeatureRow(icon: "house", title: "Title", description: "I love this title description")
}
