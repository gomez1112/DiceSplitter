//
//  DiceView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftUI

struct DiceView: View {
    @Bindable var dice: Dice
    @State private var isExploding = false
    @State private var explosionParticles: [ExplosionParticle] = []
    @Environment(Audio.self) private var audio
    
    var body: some View {
        ZStack {
            // Main dice view
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(dice.owner.color.opacity(0.2))
                .shadow(color: dice.owner.color.opacity(0.3), radius: 3, x: 0, y: 2)
                .scaleEffect(isExploding ? 1.2 : 1.0)
                .opacity(isExploding ? 0 : 1)
            
            diceImage
                .foregroundStyle(dice.owner.color)
                .contentTransition(.numericText(value: Double(dice.value)))
                .symbolEffect(.bounce, value: dice.value)
                .scaleEffect(isExploding ? 1.5 : 1.0)
                .opacity(isExploding ? 0 : 1)
                .overlay(
                    diceImage
                        .foregroundStyle(.white)
                        .opacity(dice.changeAmount)
                        .animation(.easeOut(duration: 0.3), value: dice.changeAmount)
                )
            
            // Explosion particles
            ForEach(explosionParticles) { particle in
                Circle()
                    .fill(dice.owner.color)
                    .frame(width: particle.size, height: particle.size)
                    .offset(particle.offset)
                    .opacity(particle.opacity)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(dice.value) dots, \(dice.owner.accessibilityName)")
        .accessibilityHint("Double tap to claim for \(dice.owner == .none ? "yourself" : "reinforce")")
        .overlay(alignment: .topTrailing) {
            if dice.owner != .none {
                ownershipBadge
            }
        }
        .onChange(of: dice.value) { oldValue, newValue in
            // Check if dice exploded (value reset to 1)
            if oldValue > 1 && newValue == 1 && oldValue > dice.neighbors {
                triggerExplosion()
            }
        }
    }
    
    var diceImage: some View {
        let clampedValue = max(1, min(6, dice.value))
        return Image(systemName: "die.face.\(clampedValue).fill")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding(10)
    }
    
    private var ownershipBadge: some View {
        Circle()
            .fill(dice.owner.color)
            .frame(width: 8, height: 8)
            .padding(4)
            .background(.thinMaterial, in: Circle())
            .offset(x: -4, y: 4)
            .scaleEffect(isExploding ? 0 : 1)
    }
    
    private func triggerExplosion() {
        // Create explosion particles
        explosionParticles = (0..<12).map { _ in
            ExplosionParticle()
        }
        
        // Play explosion sound and haptic
        audio.playSound(.explosion)
        audio.playHaptic(.heavy)
        
        // Animate explosion
        withAnimation(.easeOut(duration: 0.4)) {
            isExploding = true
        }
        
         // Animate particles
        withAnimation(.easeOut(duration: 0.6)) {
            for i in 0..<explosionParticles.count {
                let angle = Double(i) * (360.0 / Double(explosionParticles.count)) * .pi / Double(180)
                let distance = CGFloat.random(in: 30...60)
                explosionParticles[i].offset = CGSize(
                    width: cos(angle) * distance,
                    height: sin(angle) * distance
                )
                explosionParticles[i].opacity = 0
            }
        }
        
        // Reset after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isExploding = false
            }
            explosionParticles.removeAll()
        }
    }
}

struct ExplosionParticle: Identifiable {
    let id = UUID()
    var offset: CGSize = .zero
    var opacity: Double = 1.0
    let size: CGFloat = CGFloat.random(in: 4...8)
}


#Preview {
    DiceView(dice: Dice(row: 8, column: 11, neighbors: 3))
        .environment(Audio())
}
