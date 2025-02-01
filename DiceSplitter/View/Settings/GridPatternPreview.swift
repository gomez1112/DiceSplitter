struct GridPatternPreview: View {
    let columns: Int
    let rows: Int
    
    var body: some View {
        GeometryReader { geo in
            let cellSize = min(geo.size.width / CGFloat(columns), geo.size.height / CGFloat(rows))
            
            Canvas { context, size in
                for column in 0..<columns {
                    for row in 0..<rows {
                        let rect = CGRect(
                            x: CGFloat(column) * cellSize,
                            y: CGFloat(row) * cellSize,
                            width: cellSize - 2,
                            height: cellSize - 2
                        )
                        
                        context.fill(
                            Path(roundedRect: rect, cornerRadius: 4),
                            with: .color(.blue.opacity(0.2))
                        )
                    }
                }
            }
        }
    }
}