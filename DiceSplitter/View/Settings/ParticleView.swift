struct ParticleView: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(.white.opacity(0.05))
                        .frame(width: particle.size, height: particle.size)
                        .offset(x: particle.x, y: particle.y)
                }
            }
            .onAppear {
                generateParticles(in: geometry.size)
            }
        }
        .ignoresSafeArea() // Ensures particles extend beyond safe areas if needed
    }
    
    private func generateParticles(in size: CGSize) {
        particles = (0..<50).map { _ in
            Particle(
                x: CGFloat.random(in: -size.width / 2...size.width / 2),
                y: CGFloat.random(in: -size.height / 2...size.height / 2),
                size: CGFloat.random(in: 20...100),
                speed: CGFloat.random(in: 0.5...2)
            )
        }
    }
}


struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let speed: CGFloat
}