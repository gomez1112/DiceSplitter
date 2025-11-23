//
//  EnhancedSettingCard.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI
// MARK: - Supporting Views

struct SettingCard<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .foregroundStyle(iconColor)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                }
                
                Text(title)
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(ColorTheme.primaryText)
                
                Spacer()
            }
            
            // Content
            content()
        }
        .padding(24)
        .glassMorphism(cornerRadius: 24)
    }
}
