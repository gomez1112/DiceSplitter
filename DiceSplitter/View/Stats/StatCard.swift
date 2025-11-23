//
//  StatCard.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct StatCard<Content: View>: View {
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
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .foregroundStyle(iconColor)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                }
                
                Text(title)
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(ColorTheme.primaryText)
                
                Spacer()
            }
            
            content()
        }
        .padding(24)
        .glassMorphism(cornerRadius: 24)
        .shadow(color: ColorTheme.shadowColor.opacity(0.1), radius: 10, y: 5)
    }
}
#Preview {
    StatCard(title: "Title", icon: "house", iconColor: .green) {
        Text("Content")
    }
}
