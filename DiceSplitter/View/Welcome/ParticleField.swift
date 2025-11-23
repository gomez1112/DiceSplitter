//
//  ParticleField.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/17/25.
//

import SwiftUI

struct ParticleField: View {
    let count: Int = 60
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, size in
                let t = timeline.date.timeIntervalSinceReferenceDate
                for i in 0..<count {
                    let seed = Double(i) * 37.13
                    let x = (sin(t * 0.12 + seed) * 0.5 + 0.5) * size.width
                    let y = (cos(t * 0.08 + seed) * 0.5 + 0.5) * size.height
                    let r = CGFloat((sin(t * 0.25 + seed) * 0.5 + 0.5) * 3 + 2)
                    let opacity = Double((sin(t * 0.5 + seed) * 0.5 + 0.5) * 0.5 + 0.3)
                    ctx.opacity = opacity
                    ctx.fill(Path(ellipseIn: CGRect(x: x, y: y, width: r, height: r)), with: .color(.white))
                }
            }
        }
    }
}


#Preview {
    ParticleField()
}
