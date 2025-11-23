//
//  WelcomeScreen.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/17/25.
//

import SwiftUI

struct WelcomeScreen: View {
    
    @Binding var showWelcome: Bool
    let playerName: String
    let startGame: () -> Void
    
    // Animation states
    @State private var logoScale: CGFloat = 0
    @State private var logoRotation: Double = -180
    @State private var titleOpacity: Double = 0
    @State private var subtitleOffset: CGFloat = 50
    @State private var particlesActive = false
    @State private var diceAnimations: [Bool] = Array(repeating: false, count: 6)
    @State private var pulseAnimation = false
    @State private var confettiTrigger = 0
    
    // Interactive states
    @State private var selectedDice: Int? = nil
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundView
                    .ignoresSafeArea()
                
                ScrollView {
                    // FIXED: Dynamic positioning based on screen size
                    floatingDiceDecoration(in: geometry.size)
                    
                    // Main content
                    VStack(spacing: 0) {
                        // Logo section
                        logoSection
                            .padding(.bottom, 40)
                        
                        // Welcome message
                        welcomeMessage
                            .padding(.bottom, 60)
                        
                        // Action buttons
                        actionButtons
                            .padding(.horizontal, 40)
                            .padding(.bottom, 20)
                        
                        HStack {
                            SecondaryButton(
                                icon: "book.fill",
                                title: String(localized: "tutorial_button"),
                                color: .green
                            ) {
                                // Tutorial action
                            }
                            
                            SecondaryButton(
                                icon: "trophy.fill",
                                title: String(localized: "achievements_button"),
                                color: .orange
                            ) {
                                // Achievements action
                            }
                            
                            SecondaryButton(
                                icon: "chart.bar.fill",
                                title: String(localized: "stats_button"),
                                color: .purple
                            ) {
                                // Stats action
                            }
                        }
                        .padding(60)
                        
                        // Tips carousel
                        tipsSection
                        Spacer()
                    }
                    .padding()
                    
                    // Confetti overlay
                    if confettiTrigger > 0 {
                        ConfettiAnimation()
                            .allowsHitTesting(false)
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
            }
            .onAppear {
                animateEntrance()
            }
            .ignoresSafeArea(edges: .top)
        }
    }
    
    // MARK: - Background
    var backgroundView: some View {
        ZStack {
            gradientBackground
            animatedMeshGradient
            particleEffect
        }
    }
    
    private var animatedMeshGradient: some View {
        TimelineView(.animation) { timeline in
            meshGradientView(time: timeline.date.timeIntervalSince1970)
        }
    }
    
    @ViewBuilder
    private var particleEffect: some View {
        if particlesActive {
            ParticleField()
                .opacity(0.6)
        }
    }
    
    private func meshGradientView(time: TimeInterval) -> some View {
        MeshGradient(
            width: 4,
            height: 4,
            points: [
                [0, 0], [0.25, 0], [0.75, 0], [1, 0],
                [0, 0.33], [sin(Float(time)) * 0.1 + 0.25, 0.33], [cos(Float(time)) * 0.1 + 0.75, 0.33], [1, 0.33],
                [0, 0.67], [cos(Float(time)) * 0.1 + 0.25, 0.67], [sin(Float(time)) * 0.1 + 0.75, 0.67], [1, 0.67],
                [0, 1], [0.25, 1], [0.75, 1], [1, 1]
            ],
            colors: [
                .blue.opacity(0.3), .purple.opacity(0.3), .pink.opacity(0.3), .blue.opacity(0.3),
                .purple.opacity(0.4), .pink.opacity(0.5), .blue.opacity(0.5), .purple.opacity(0.4),
                .pink.opacity(0.4), .blue.opacity(0.5), .purple.opacity(0.5), .pink.opacity(0.4),
                .blue.opacity(0.3), .purple.opacity(0.3), .pink.opacity(0.3), .blue.opacity(0.3)
            ]
        )
        .opacity(0.5)
        .blur(radius: 30)
    }
    
    private var gradientBackground: some View {
        LinearGradient(
            stops: [
                .init(color: Color(hex: "1a1a2e"), location: 0),
                .init(color: Color(hex: "16213e"), location: 0.5),
                .init(color: Color(hex: "0f3460"), location: 1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Floating Dice (FIXED: Dynamic positioning)
    func floatingDiceDecoration(in size: CGSize) -> some View {
        ZStack {
            ForEach(0..<6) { index in
                FloatingDice(
                    number: index + 1,
                    delay: Double(index) * 0.2,
                    isActive: diceAnimations[index]
                )
                .position(dicePosition(for: index, in: size))
                .onTapGesture {
                    diceInteraction(index: index)
                }
            }
        }
    }
    
    // MARK: - Logo Section
    var logoSection: some View {
        VStack(spacing: 20) {
            // Animated logo
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.blue.opacity(0.6),
                                Color.purple.opacity(0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .blur(radius: 20)
                    .opacity(pulseAnimation ? 1 : 0.6)
                
                // Main dice logo
                Image(systemName: "die.face.6.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotationEffect(.degrees(logoRotation))
                    .scaleEffect(logoScale)
                    .shadow(color: .blue, radius: 20)
                    .overlay(
                        Image(systemName: "sparkle")
                            .font(.system(size: 30))
                            .foregroundColor(.yellow)
                            .offset(x: 40, y: -40)
                            .opacity(pulseAnimation ? 1 : 0)
                            .scaleEffect(pulseAnimation ? 1.2 : 0.8)
                    )
            }
            .onTapGesture {
                triggerLogoAnimation()
            }
            .accessibilityLabel(String(localized: "app_logo"))
            .accessibilityHint(String(localized: "tap_to_spin"))
            
            // App name with shimmer effect
            Text("DiceSplitter")
                .font(.system(size: 48, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .blue.opacity(0.8), .purple.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .opacity(titleOpacity)
        }
    }
    
    // MARK: - Welcome Message
    var welcomeMessage: some View {
        VStack(spacing: 16) {
            Text("welcome_message \(playerName.isEmpty ? String(localized: "default_player_name") : playerName)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .opacity(titleOpacity)
            
            Text(String(localized: "welcome_subtitle"))
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .offset(y: subtitleOffset)
                .opacity(subtitleOffset == 0 ? 1 : 0)
        }
    }
    
    // MARK: - Action Buttons
    var actionButtons: some View {
        VStack {
            // Play button
            Button(action: {
                playButtonTapped()
            }) {
                HStack(spacing: 16) {
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                    
                    Text(String(localized: "start_playing_button"))
                        .font(.title3.bold())
                    
                    Image(systemName: "arrow.right")
                        .font(.title3)
                }
                .foregroundColor(.white)
                .padding()
                .background(
                    ZStack {
                        // Gradient background
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        
                        // Animated shine effect
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.3), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 60)
                        .rotationEffect(.degrees(30))
                        .offset(x: pulseAnimation ? 150 : -150)
                        .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: pulseAnimation)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .shadow(color: .blue.opacity(0.5), radius: 20, y: 10)
                .scaleEffect(pulseAnimation ? 1.05 : 1)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
            }
            .accessibilityLabel(String(localized: "start_new_game"))
            .accessibilityHint(String(localized: "begins_new_game_hint"))
        }
    }
    
    // MARK: - Tips Section
    var tipsSection: some View {
        VStack(spacing: 12) {
            Text(String(localized: "quick_tip_label"))
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    TipCard(
                        icon: "lightbulb.fill",
                        text: String(localized: "tip_claim_dice"),
                        color: .yellow
                    )
                    
                    TipCard(
                        icon: "star.fill",
                        text: String(localized: "tip_chain_reactions"),
                        color: .orange
                    )
                    
                    TipCard(
                        icon: "flag.fill",
                        text: String(localized: "tip_win_condition"),
                        color: .green
                    )
                }
                .padding(.horizontal)
            }
        }
        .opacity(titleOpacity)
    }
    
    // MARK: - Helper Functions
    private func animateEntrance() {
        // Logo animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            logoScale = 1
            logoRotation = 0
        }
        
        // Title fade in
        withAnimation(.easeOut(duration: 0.8).delay(0.5)) {
            titleOpacity = 1
        }
        
        // Subtitle slide up
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8)) {
            subtitleOffset = 0
        }
        
        // Activate animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            particlesActive = true
            pulseAnimation = true
            
            // Animate floating dice
            for i in 0..<6 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                    diceAnimations[i] = true
                }
            }
        }
    }
    
    private func playButtonTapped() {
        // Trigger celebration
        confettiTrigger += 1
        
        // Haptic feedback
#if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
#endif
        
        // Delay and start game
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showWelcome = false
            }
            startGame()
        }
    }
    
    private func triggerLogoAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            logoRotation += 360
        }
        
#if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
#endif
    }
    
    private func diceInteraction(index: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            selectedDice = index
        }
        
#if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
#endif
    }
    
    // FIXED: Dynamic positioning based on screen size
    private func dicePosition(for index: Int, in size: CGSize) -> CGPoint {
        let padding: CGFloat = 80
        let positions: [CGPoint] = [
            CGPoint(x: padding, y: size.height * 0.15),
            CGPoint(x: size.width - padding, y: size.height * 0.12),
            CGPoint(x: padding * 0.75, y: size.height * 0.4),
            CGPoint(x: size.width - padding * 0.75, y: size.height * 0.38),
            CGPoint(x: padding * 1.25, y: size.height * 0.6),
            CGPoint(x: size.width - padding * 1.25, y: size.height * 0.58)
        ]
        return positions[min(index, positions.count - 1)]
    }
}

#Preview {
    WelcomeScreen(showWelcome: .constant(true), playerName: "Gerard", startGame: {})
}
