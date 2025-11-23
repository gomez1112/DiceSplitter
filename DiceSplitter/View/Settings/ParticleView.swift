//
//  ParticleView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct ParticleView: View {
    @State private var particles: [Particle] = []
    @State private var animationTask: Task<Void, Never>? // FIXED: Track animation task
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    private var particleCount: Int {
        // Use size classes to approximate device category without deprecated APIs
        let isPadLike = (horizontalSizeClass == .regular && verticalSizeClass == .regular)
        if isPadLike {
            return 50
        } else {
            // iPhone-like; use a conservative default. Actual height thresholds will be applied
            // using GeometryReader size when generating particles.
            return 40
        }
    }
    
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
            .onChange(of: geometry.size) { _, newSize in
                generateParticles(in: newSize)
            }
            .onDisappear {
                // FIXED: Cancel animation task
                animationTask?.cancel()
                animationTask = nil
                particles.removeAll()
            }
        }
        .ignoresSafeArea()
    }
    
    private func generateParticles(in size: CGSize) {
        // Cancel existing animation
        animationTask?.cancel()
        
        // Adjust count based on current geometry height for iPhone-like layouts
        var count = particleCount
        let isPadLike = (horizontalSizeClass == .regular && verticalSizeClass == .regular)
        if !isPadLike {
            let screenHeight = size.height
            if screenHeight <= 667 { // iPhone SE, 6, 7, 8
                count = 20
            } else if screenHeight <= 844 { // iPhone 12, 13, 14
                count = 30
            } else { // iPhone Pro Max and larger
                count = 40
            }
        }
        
        particles = (0..<count).map { _ in
            Particle(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height),
                size: CGFloat.random(in: 20...100),
                speed: CGFloat.random(in: 0.5...2)
            )
        }
        
        // FIXED: Use Task for animation control
        animationTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(0.016)) // ~60 FPS
                await MainActor.run {
                    animateParticles(in: size)
                }
            }
        }
    }
    
    private func animateParticles(in size: CGSize) {
        for i in particles.indices {
            particles[i].y += particles[i].speed
            
            // Reset particle when it goes off screen
            if particles[i].y > size.height + particles[i].size {
                particles[i].y = -particles[i].size
                particles[i].x = CGFloat.random(in: 0...size.width)
            }
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
