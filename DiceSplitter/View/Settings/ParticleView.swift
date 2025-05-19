//
//  ParticleView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct ParticleView: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(.white.opacity(0.05))
                        .frame(width: particle.size, height: particle.size)
                        .position(x: particle.x, y: particle.y)
                }
            }
            .onAppear {
                generateParticles(in: geometry.size)
            }
            .onChange(of: geometry.size) {_, newSize in
                generateParticles(in: newSize)
            }
        }
        .ignoresSafeArea()
    }
    
    private func generateParticles(in size: CGSize) {
        particles = (0..<50).map { _ in
            Particle(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height),
                size: CGFloat.random(in: 20...100),
                speed: CGFloat.random(in: 0.5...2)
            )
        }
    }
}

#Preview {
    ParticleView()
}

struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let speed: CGFloat
}
