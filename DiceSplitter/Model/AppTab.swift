//
//  AppTab.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/17/25.
//

import SwiftUI

// MARK: - Navigation System
enum Tabs: String, CaseIterable, Identifiable {
    case play = "Play"
    case stats = "Statistics"
    case settings = "Settings"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .play: return "die.face.6"
        case .stats: return "chart.bar.fill"
        case .settings: return "gear"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .play: return "die.face.6"
        case .stats: return "chart.bar"
        case .settings: return "gear.circle"
        }
    }
    
    @ViewBuilder
    var tabLabel: some View {
        Label(rawValue, systemImage: icon)
    }
}
