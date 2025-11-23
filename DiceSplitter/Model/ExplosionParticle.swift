//
//  ExplosionParticle.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/9/25.
//

import SwiftUI

struct ExplosionParticle: Identifiable {
    let id = UUID()
    var offset: CGSize = .zero
    var opacity: Double = 1.0
    var size: CGFloat = CGFloat.random(in: 6...12)
}
