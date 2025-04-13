//
//  MeshGradientView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct MeshGradientView: View {
    var body: some View {
        TimelineView(.everyMinute) { timeline in
            let x = (sin(timeline.date.timeIntervalSince1970) + 2) / 2
            MeshGradient(width: 3, height: 3, points: [
                [0, 0], [0.5, 0], [1, 0],
                [0, 0.5], [Float(x), 0.5], [1, 0.5],
                [0, 1], [0.5, 1], [1, 1]
            ], colors: [
                .blue, .blue, .blue,
                .purple, .purple, .purple,
                .cyan, .cyan, .cyan
            ])
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MeshGradientView()
}
