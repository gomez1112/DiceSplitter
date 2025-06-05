//
//  ConfettiPiece.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 6/5/25.
//

import Foundation
import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    let color: Color
    let size: CGFloat
    let startX: CGFloat
    let startY: CGFloat
    let endY: CGFloat
    let rotation: Double
    let duration: Double
}
