//
//  ConfettiPiece.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 6/5/25.
//

import Foundation
import SwiftUI

struct ConfettiPiece: Identifiable {
    enum Shape {
        case circle, rectangle
    }
    
    let id = UUID()
    let shape: Shape
    let color: Color
    let size: CGFloat
    let startX: CGFloat
    let startY: CGFloat
    let endY: CGFloat
    let horizontalMovement: CGFloat
    let rotation: Double
    let duration: Double
    let delay: Double
}
