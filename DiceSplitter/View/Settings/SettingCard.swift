//
//  SettingCard.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct SettingCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder var content:  () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.title3)
                Text(title)
                    .font(.headline.bold())
                Spacer()
            }
            
            content()
             .settingsCardContentStyle()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}
