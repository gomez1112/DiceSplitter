//
//  ParticleDot.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/17/25.
//

import SwiftUI

struct ParticleDot: View {
    @State private var offset = CGSize.zero
    @State private var opacity = Double.random(in: 0.1...0.5)
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: CGFloat.random(in: 2...6))
            .opacity(opacity)
            .offset(offset)
            .onAppear {
                withAnimation(.linear(duration: Double.random(in: 5...15)).repeatForever(autoreverses: true)) {
                    offset = CGSize(width: CGFloat.random(in: -50...50), height: CGFloat.random(in: -50...50))
                    opacity = Double.random(in: 0.3...0.8)
                }
            }
    }
}

#Preview {
    ParticleDot()
}
