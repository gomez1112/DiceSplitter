//
//  NeonGlow.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI

struct NeonGlow: ViewModifier {
    let color: Color
    let intensity: Double
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.8), radius: intensity * 2)
            .shadow(color: color.opacity(0.6), radius: intensity * 4)
            .shadow(color: color.opacity(0.4), radius: intensity * 8)
    }
}
