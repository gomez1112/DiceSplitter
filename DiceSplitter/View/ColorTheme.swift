//
//  ColorTheme.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI

// MARK: - Color Theme
struct ColorTheme {
    // Primary Colors
    static let primary = Color(hex: "007AFF")
    static let secondary = Color(hex: "5856D6")
    static let accent = Color(hex: "FF9500")
    
    // Background Colors
    static let background = Color(hex: "000000")
    static let secondaryBackground = Color(hex: "1C1C1E")
    static let tertiaryBackground = Color(hex: "2C2C2E")
    
    // Surface Colors
    static let surface = Color(hex: "2C2C2E").opacity(0.6)
    static let elevatedSurface = Color(hex: "3A3A3C").opacity(0.8)
    
    // Text Colors
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.6)
    static let tertiaryText = Color.white.opacity(0.3)
    
    // Player Colors - Vibrant and Consistent
    static let playerGreen = Color(hex: "32D74B")
    static let playerRed = Color(hex: "FF453A")
    static let playerBlue = Color(hex: "007AFF")
    static let playerYellow = Color(hex: "FFD60A")
    static let playerNone = Color(hex: "8E8E93")
    
    // Semantic Colors
    static let success = Color(hex: "32D74B")
    static let warning = Color(hex: "FF9500")
    static let error = Color(hex: "FF453A")
    static let info = Color(hex: "5AC8FA")
    
    // Gradient Colors
    static let gradientStart = Color(hex: "007AFF")
    static let gradientEnd = Color(hex: "5856D6")
    
    // Material Effects
    static let glowColor = Color(hex: "007AFF").opacity(0.6)
    static let shadowColor = Color.black.opacity(0.3)
}
