//
//  DiceView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftUI

struct DiceView: View {
    @AppStorage("soundEnabled") var soundEnabled = true
    @AppStorage("hapticEnabled") var hapticEnabled = true
    
    @Bindable var dice: Dice
    @State private var isExploding = false
    @State private var explosionParticles: [ExplosionParticle] = []
    @State private var isPressed = false
    @State private var pulseAnimation = false
    @Environment(Audio.self) private var audio
    
    var body: some View {
        ZStack {
            // Background glow effect
            if dice.owner != .none {
                Circle()
                    .fill(dice.owner.color)
                    .blur(radius: 20)
                    .opacity(pulseAnimation ? 0.4 : 0.2)
                    .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulseAnimation)
            }
            
            // Main dice container
            ZStack {
                // Glass morphism background
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        dice.owner.color.opacity(0.3),
                                        dice.owner.color.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        dice.owner.color.opacity(0.5),
                                        dice.owner.color.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: dice.owner.color.opacity(0.3), radius: 6, x: 0, y: 4)
                    .scaleEffect(isExploding ? 1.3 : (isPressed ? 0.95 : 1.0))
                    .opacity(isExploding ? 0 : 1)
                
                // Dice face
                diceImage
                    .foregroundStyle(dice.owner == .none ? ColorTheme.secondaryText : dice.owner.color)
                    .contentTransition(.numericText(value: Double(dice.value)))
                    .symbolEffect(.bounce, value: dice.value)
                    .scaleEffect(isExploding ? 1.5 : (isPressed ? 0.9 : 1.0))
                    .opacity(isExploding ? 0 : 1)
                    .shadow(color: dice.owner.color.opacity(0.5), radius: 2)
                    .overlay(
                        diceImage
                            .foregroundStyle(.white)
                            .opacity(dice.changeAmount * 0.8)
                            .blur(radius: 2)
                            .animation(.easeOut(duration: 0.3), value: dice.changeAmount)
                    )
                
                // Value indicator for high numbers
                if dice.value > 6 {
                    Text("\(dice.value)")
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(4)
                        .background(
                            Capsule()
                                .fill(dice.owner.color)
                                .shadow(color: dice.owner.color.opacity(0.5), radius: 4)
                        )
                        .offset(x: 20, y: -20)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            
            // Explosion particles
            ForEach(explosionParticles) { particle in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [dice.owner.color, dice.owner.color.opacity(0)],
                            center: .center,
                            startRadius: 0,
                            endRadius: particle.size / 2
                        )
                    )
                    .frame(width: particle.size, height: particle.size)
                    .offset(particle.offset)
                    .opacity(particle.opacity)
                    .blur(radius: particle.opacity < 0.5 ? 2 : 0)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(dice.value) dots, \(dice.owner.accessibilityName)")
        .accessibilityHint("Double tap to claim for \(dice.owner == .none ? "yourself" : "reinforce")")
        .overlay(alignment: .topTrailing) {
            if dice.owner != .none {
                ownershipBadge
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onAppear {
            if dice.owner != .none {
                pulseAnimation = true
            }
        }
        .onChange(of: dice.value) { oldValue, newValue in
            // Check if dice exploded (value reset to 1)
            if oldValue > 1 && newValue == 1 && oldValue > dice.neighbors {
                triggerExplosion()
            }
        }
        .onChange(of: dice.owner) { _, newOwner in
            if newOwner != .none {
                withAnimation(.easeInOut(duration: 0.5)) {
                    pulseAnimation = true
                }
            }
        }
    }
    
    var diceImage: some View {
        let clampedValue = max(1, min(6, dice.value))
        return ZStack {
            // Dice background
            Image(systemName: "square.fill")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(.ultraThinMaterial)
                .opacity(0.3)
            
            // Dice face
            Image(systemName: "die.face.\(clampedValue).fill")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(8)
        }
    }
    
    private var ownershipBadge: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(dice.owner.color)
                .frame(width: 16, height: 16)
                .blur(radius: 4)
                .opacity(0.6)
            
            // Inner badge
            Circle()
                .fill(dice.owner.color)
                .frame(width: 10, height: 10)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                )
        }
        .offset(x: -6, y: 6)
        .scaleEffect(isExploding ? 0 : 1)
    }
    
    private func triggerExplosion() {
        // Create explosion particles with enhanced effects
        explosionParticles = (0..<20).map { _ in
            ExplosionParticle()
        }
        
        // Play explosion sound and haptic
        audio.playSound(soundEnabled, .explosion)
        audio.playHaptic(hapticEnabled, .heavy)
        
        // Animate explosion
        withAnimation(.easeOut(duration: 0.4)) {
            isExploding = true
        }
        
        // Animate particles with physics-like motion
        withAnimation(.easeOut(duration: 0.8)) {
            for i in 0..<explosionParticles.count {
                let angle = Double(i) * (360.0 / Double(explosionParticles.count)) * .pi / Double(180)
                let distance = CGFloat.random(in: 40...80)
                let randomOffset = CGFloat.random(in: -10...10)
                explosionParticles[i].offset = CGSize(
                    width: cos(angle) * distance + randomOffset,
                    height: sin(angle) * distance + randomOffset
                )
                explosionParticles[i].opacity = 0
                explosionParticles[i].size *= CGFloat.random(in: 0.5...1.5)
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


#Preview {
    DiceView(dice: Dice(row: 8, column: 11, neighbors: 3))
        .environment(Audio())
}
