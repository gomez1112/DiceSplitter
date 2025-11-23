//
//  GridPatternPreview.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI


struct GridPatternPreview: View {
    let columns: Int
    let rows: Int
    @State private var animatedCells = Set<Int>()
    @State private var animationTask: Task<Void, Never>?
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = min(
                geometry.size.width / CGFloat(columns),
                geometry.size.height / CGFloat(rows)
            ) - 2
            
            ZStack {
                ForEach(0..<(columns * rows), id: \.self) { index in
                    let column = index % columns
                    let row = index / columns
                    
                    RoundedRectangle(cornerRadius: cellSize * 0.2)
                        .fill(
                            animatedCells.contains(index)
                            ? ColorTheme.primary.opacity(0.6)
                            : ColorTheme.tertiaryText.opacity(0.3)
                        )
                        .frame(width: cellSize, height: cellSize)
                        .position(
                            x: CGFloat(column) * (cellSize + 2) + cellSize/2,
                            y: CGFloat(row) * (cellSize + 2) + cellSize/2
                        )
                        .animation(.easeInOut(duration: 0.3), value: animatedCells)
                }
            }
            .onAppear {
                animationTask = Task { @MainActor in
                    while !Task.isCancelled {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            animatedCells = randomSet()
                        }
                        try? await Task.sleep(for: .milliseconds(500))
                    }
                }
            }
            .onDisappear { animationTask?.cancel() }
        }
    }
    private func randomSet() -> Set<Int> {
        var set = Set<Int>()
        for _ in 0..<max(1, (columns * rows) / 4) {
            set.insert(Int.random(in: 0..<(columns * rows)))
        }
        return set
    }
}

#Preview {
    GridPatternPreview(columns: 2, rows: 2)
}
