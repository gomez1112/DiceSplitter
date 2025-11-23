//
//  PerformanceChart.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import Charts
import SwiftUI

struct PerformanceChart: View {
    let wins: Int
    let losses: Int
    let draws: Int
    
    var data: [(String, Int, Color)] {
        [
            ("Wins", wins, ColorTheme.success),
            ("Losses", losses, ColorTheme.error),
            ("Draws", draws, ColorTheme.warning)
        ]
    }
    
    var body: some View {
        Chart(data, id: \.0) { item in
            SectorMark(
                angle: .value("Count", item.1),
                innerRadius: .ratio(0.5)
            )
            .foregroundStyle(item.2)
            .opacity(0.8)
        }
        .chartBackground { _ in
            Text("\(wins + losses + draws)")
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundStyle(ColorTheme.primaryText)
        }
    }
}

#Preview {
    PerformanceChart(wins: 4, losses: 2, draws: 2)
}
