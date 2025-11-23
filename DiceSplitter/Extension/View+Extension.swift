//
//  View+Extension.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import Foundation
import SwiftUI


extension View {
    func glassMorphism(cornerRadius: CGFloat = 20) -> some View {
        modifier(GlassMorphism(cornerRadius: cornerRadius))
    }
    
    func neonGlow(color: Color, intensity: Double = 4) -> some View {
        modifier(NeonGlow(color: color, intensity: intensity))
    }
    func floating(delay: Double = 0) -> some View {
        modifier(FloatingAnimation(delay: delay))
    }
    
    func shimmer(duration: Double = 2.0) -> some View {
        modifier(ShimmerEffect(duration: duration))
    }
}
