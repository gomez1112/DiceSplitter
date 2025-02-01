//
//  DualSlider.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct DualSlider: View {
    let widthLabel: String
    let heightLabel: String
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    let range: ClosedRange<CGFloat>
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text(widthLabel)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Slider(value: $width, in: range)
                    .accentColor(.blue)
            }
            
            VStack(alignment: .leading) {
                Text(heightLabel)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Slider(value: $height, in: range)
                    .accentColor(.blue)
            }
        }
    }
}

#Preview {
    DualSlider(widthLabel: "Min", heightLabel: "Max", width: .constant(100.0), height: .constant(100.0), range: 2...10)
}
