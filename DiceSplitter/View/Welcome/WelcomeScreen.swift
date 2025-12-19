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
    
    @State private var viewModel = WelcomeViewModel()
    
    var body: some View {
        ZStack {
            WelcomeBackgroundView(particlesActive: viewModel.particlesActive)
            
            ScrollView {
                WelcomeFloatingDiceField(viewModel: viewModel)
                VStack {
                    WelcomeHeroLogoView(viewModel: viewModel)
                        .padding(.bottom)
                    WelcomeMessageView(playerName: playerName, titleOpacity: viewModel.titleOpacity, subtitleOffset: viewModel.subtitleOffset)
                        .padding(.bottom)
                    WelcomeActionButtonsView(
                        viewModel: viewModel,
                        showWelcome: $showWelcome,
                        startGame: startGame
                    )
                    SecondaryActionsRow()
                    WelcomeTipsView(titleOpacity: viewModel.titleOpacity)
                    Spacer()
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            .overlay {
                if viewModel.confettiTrigger > 0 {
                    ConfettiAnimation()
                        .allowsHitTesting(false)
                }
            }
        }
        .task {
            viewModel.startEntranceAnimation()
        }
        .ignoresSafeArea(edges: .top)
    }
}

struct WelcomeBackgroundView: View {
    let particlesActive: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Color(hex: "1a1a2e"), location: 0),
                    .init(color: Color(hex: "16213e"), location: 0.5),
                    .init(color: Color(hex: "0f3460"), location: 1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            AnimatedMeshGradientView()
            if particlesActive {
                ParticleField()
                    .opacity(0.6)
            }
        }
    }
}

struct AnimatedMeshGradientView: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            meshGradientView(time: timeline.date.timeIntervalSince1970)
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
}

struct WelcomeFloatingDiceField: View {
    @Bindable var viewModel: WelcomeViewModel

    var body: some View {
        ZStack {
            ForEach(0..<viewModel.diceAnimations.count, id: \.self) { index in
                Button {
                    viewModel.selectDice(index: index)
                } label: {
                    FloatingDice(
                        number: index + 1,
                        delay: Double(index) * 0.2,
                        isActive: viewModel.diceAnimations[index],
                        isSelected: viewModel.selectedDice == index
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Select dice \(index + 1)")
                .position(viewModel.dicePosition(for: index))
            }
        }
        .sensoryFeedback(.impact, trigger: viewModel.diceHapticTrigger)
    }
}

struct WelcomeHeroLogoView: View {
    @Bindable var viewModel: WelcomeViewModel

    var body: some View {
        VStack {
            Button {
                viewModel.triggerLogoAnimation()
            } label: {
                ZStack {
                    Text("Celebrate")
                        .font(.caption2)
                        .opacity(0)

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
                        .opacity(viewModel.pulseAnimation ? 1 : 0.6)

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
                        .rotationEffect(.degrees(viewModel.logoRotation))
                        .scaleEffect(viewModel.logoScale)
                        .shadow(color: .blue, radius: 20)
                        .overlay(
                            Image(systemName: "sparkle")
                                .font(.title)
                                .foregroundStyle(.yellow)
                                .offset(x: 40, y: -40)
                                .opacity(viewModel.pulseAnimation ? 1 : 0)
                                .scaleEffect(viewModel.pulseAnimation ? 1.2 : 0.8)
                        )
                        .symbolEffect(.pulse, value: viewModel.pulseAnimation)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Celebrate the launch")
            .sensoryFeedback(.impact, trigger: viewModel.logoHapticTrigger)

            Text("DiceSplitter")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .blue.opacity(0.8), .purple.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .opacity(viewModel.titleOpacity)
        }
    }
}

struct WelcomeMessageView: View {
    let playerName: String
    let titleOpacity: Double
    let subtitleOffset: CGFloat

    var body: some View {
        VStack {
            Text("Welcome, \(playerName.isEmpty ? "Player" : playerName)!")
                .font(.title)
                .bold()
                .foregroundStyle(.white)
                .opacity(titleOpacity)

            Text("Your journey to dice domination begins now")
                .font(.body)
                .foregroundStyle(.white.opacity(0.8))
                .offset(y: subtitleOffset)
                .opacity(subtitleOffset == 0 ? 1 : 0)
        }
    }
}

struct WelcomeActionButtonsView: View {
    @Bindable var viewModel: WelcomeViewModel
    @Binding var showWelcome: Bool
    let startGame: () -> Void

    var body: some View {
        VStack {
            Button {
                Task {
                    await playButtonTapped()
                }
            } label: {
                HStack {
                    Label("Start Playing", systemImage: "play.circle.fill")
                        .labelStyle(.titleAndIcon)
                        .font(.title3)
                    Image(systemName: "arrow.right")
                        .font(.title3)
                }
                .foregroundStyle(.white)
                .padding()
                .background(
                    ZStack {
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )

                        LinearGradient(
                            colors: [.clear, .white.opacity(0.3), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 60)
                        .rotationEffect(.degrees(30))
                        .offset(x: viewModel.pulseAnimation ? 150 : -150)
                        .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: viewModel.pulseAnimation)
                    }
                )
                .clipShape(.rect(cornerRadius: 25))
                .shadow(color: .blue.opacity(0.5), radius: 20, y: 10)
                .scaleEffect(viewModel.pulseAnimation ? 1.05 : 1)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: viewModel.pulseAnimation)
            }
            .sensoryFeedback(.success, trigger: viewModel.confettiTrigger)
        }
    }

    @MainActor
    private func playButtonTapped() async {
        viewModel.triggerConfetti()
        try? await Task.sleep(for: .seconds(0.5))
        withAnimation(.easeInOut(duration: 0.3)) {
            showWelcome = false
        }
        startGame()
    }
}

struct SecondaryActionsRow: View {
    var body: some View {
        HStack {
            SecondaryButton(
                icon: "book.fill",
                title: "Tutorial",
                color: .green
            ) {
                // Tutorial action
            }

            SecondaryButton(
                icon: "trophy.fill",
                title: "Achievements",
                color: .orange
            ) {
                // Achievements action
            }

            SecondaryButton(
                icon: "chart.bar.fill",
                title: "Stats",
                color: .purple
            ) {
                // Stats action
            }
        }
        .padding()
    }
}

struct WelcomeTipsView: View {
    let titleOpacity: Double

    var body: some View {
        VStack {
            Text("Quick Tip")
                .font(.caption)
                .bold()
                .foregroundStyle(.white.opacity(0.6))

            ScrollView(.horizontal) {
                HStack {
                    TipCard(
                        icon: "lightbulb.fill",
                        text: "Tap dice to claim them and increase their value",
                        color: .yellow
                    )

                    TipCard(
                        icon: "star.fill",
                        text: "Chain reactions happen when dice exceed their neighbor count",
                        color: .orange
                    )

                    TipCard(
                        icon: "flag.fill",
                        text: "Control all dice or have the highest score to win",
                        color: .green
                    )
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
        .opacity(titleOpacity)
    }
}

#Preview {
    WelcomeScreen(showWelcome: .constant(true), playerName: "Gerard", startGame: {})
}
