//
//  TabSelector.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct TabSelector: View {
    @Binding var selectedTab: Int
    @Namespace private var namespace
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(
                title: "Statistics",
                icon: "chart.bar.fill",
                isSelected: selectedTab == 0,
                namespace: namespace
            ) {
                selectedTab = 0
            }
            
            TabButton(
                title: "Achievements",
                icon: "trophy.fill",
                isSelected: selectedTab == 1,
                namespace: namespace
            ) {
                selectedTab = 1
            }
        }
        .padding(4)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    @Previewable @State var selectedTab: Int = 0
    TabSelector(selectedTab: $selectedTab)
}
