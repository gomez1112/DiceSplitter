//
//  Audio.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 6/5/25.
//

import SwiftUI
import AVFoundation
#if os(iOS)
import UIKit
#endif

@MainActor
@Observable
final class Audio {
    @ObservationIgnored
    @AppStorage("soundEnabled") var soundEnabled = true
    @ObservationIgnored
    @AppStorage("hapticEnabled") var hapticEnabled = true
    
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    init() {
        loadSounds()
    }
    
    private func loadSounds() {
        // In a real app, you would load actual sound files
        // For now, we'll use system sounds
#if os(iOS)
        // Prepare audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
#endif
    }
    
    func playSound(_ sound: GameSound) {
        guard soundEnabled else { return }
        
#if os(iOS)
        // Play system sounds as placeholders
        switch sound {
            case .tap:
                AudioServicesPlaySystemSound(1104) // Keyboard tap
            case .explosion:
                AudioServicesPlaySystemSound(1521) // SMS received
            case .win:
                AudioServicesPlaySystemSound(1025) // New mail
            case .lose:
                AudioServicesPlaySystemSound(1073) // Mail sent
            case .move:
                AudioServicesPlaySystemSound(1306) // Lock sound
        }
#else
        // macOS sound implementation
        NSSound.beep()
#endif
    }
    
    func playHaptic(_ type: HapticType) {
        guard hapticEnabled else { return }
        
#if os(iOS)
        switch type {
            case .light:
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.prepare()
                generator.impactOccurred()
            case .medium:
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()
            case .heavy:
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.prepare()
                generator.impactOccurred()
            case .success:
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(.success)
            case .warning:
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(.warning)
            case .error:
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(.error)
        }
#endif
    }
}

enum GameSound {
    case tap
    case explosion
    case win
    case lose
    case move
}

enum HapticType {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
}
