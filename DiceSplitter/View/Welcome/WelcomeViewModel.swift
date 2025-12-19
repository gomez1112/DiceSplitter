//
//  WelcomeViewModel.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 9/22/25.
//

import SwiftUI

@MainActor
@Observable
final class WelcomeViewModel {
    var logoScale: CGFloat = 0
    var logoRotation: Double = -180
    var titleOpacity: Double = 0
    var subtitleOffset: CGFloat = 50
    var particlesActive = false
    var diceAnimations: [Bool] = Array(repeating: false, count: 6)
    var pulseAnimation = false
    var confettiTrigger = 0
    var selectedDice: Int? = nil
    var logoHapticTrigger = 0
    var diceHapticTrigger = 0

    private var entranceTask: Task<Void, Never>?

    func startEntranceAnimation() {
        entranceTask?.cancel()
        entranceTask = Task { @MainActor in
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                logoScale = 1
                logoRotation = 0
            }

            withAnimation(.easeOut(duration: 0.8).delay(0.5)) {
                titleOpacity = 1
            }

            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8)) {
                subtitleOffset = 0
            }

            try? await Task.sleep(for: .seconds(1.5))
            guard !Task.isCancelled else { return }

            particlesActive = true
            pulseAnimation = true

            for index in 0..<diceAnimations.count {
                try? await Task.sleep(for: .seconds(0.1))
                guard !Task.isCancelled else { return }
                diceAnimations[index] = true
            }
        }
    }

    func triggerConfetti() {
        confettiTrigger += 1
    }

    func triggerLogoAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            logoRotation += 360
        }
        logoHapticTrigger += 1
    }

    func selectDice(index: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            selectedDice = index
        }
        diceHapticTrigger += 1
    }

    func dicePosition(for index: Int) -> CGPoint {
        let positions: [CGPoint] = [
            CGPoint(x: 80, y: 150),
            CGPoint(x: 320, y: 120),
            CGPoint(x: 60, y: 400),
            CGPoint(x: 340, y: 380),
            CGPoint(x: 100, y: 600),
            CGPoint(x: 300, y: 580)
        ]
        return positions[min(index, positions.count - 1)]
    }
}
