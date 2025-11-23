//
//  TabButton.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(.body, design: .rounded))
                Text(title)
                    .font(.system(.body, design: .rounded).weight(.semibold))
            }
            .foregroundStyle(isSelected ? .white : ColorTheme.secondaryText)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background {
                if isSelected {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [ColorTheme.primary, ColorTheme.secondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .matchedGeometryEffect(id: "tab", in: namespace)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    @Previewable @Namespace var namespace
    TabButton(title: "Title", icon: "house", isSelected: true, namespace: namespace, action: {})
}
