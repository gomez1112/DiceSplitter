//
//  FloatingAnimation.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI

// MARK: - Floating Animation
struct FloatingAnimation: ViewModifier {
    @State private var isFloating = false
    let delay: Double
    
    func body(content: Content) -> some View {
        content
            .offset(y: isFloating ? -10 : 10)
            .animation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                    .delay(delay),
                value: isFloating
            )
            .onAppear {
                isFloating = true
            }
    }
}
