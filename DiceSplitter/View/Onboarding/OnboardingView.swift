//
//  OnboardingView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var mapSize: CGSize
    @Binding var playerType: PlayerType
    @Binding var numberOfPlayers: Int
    @Binding var aiDifficulty: AIDifficulty
    @State private var currentPage = 0
    let completion: () -> Void
    
    var body: some View {
        ZStack {
            MeshGradientView()
            ParticleView()
                .blendMode(.plusLighter)
            
            VStack(spacing: 30) {
#if os(iOS)
                TabView(selection: $currentPage) {
                    pageContent
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .animation(.easeInOut, value: currentPage)
#else
                // macOS version without page style
                VStack {
                    pageContent
                    
                    // Page indicator for macOS
                    HStack(spacing: 8) {
                        ForEach(0..<5) { index in
                            Circle()
                                .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    .padding(.top)
                }
#endif
                
                HStack {
                    if currentPage > 0 {
                        Button("Back") {
                            currentPage -= 1
                        }
                        .keyboardShortcut(.leftArrow)
                    }
                    
                    Spacer()
                    
                    if currentPage < 4 {
                        Button("Next") {
                            currentPage += 1
                        }
                        .keyboardShortcut(.rightArrow)
                    } else {
                        Button("Get Started") {
                            completion()
                        }
                        .keyboardShortcut(.return)
                    }
                }
                .padding()
            }
            .padding()
        }
        .transition(.opacity)
#if os(macOS)
        .frame(minWidth: 600, minHeight: 700)
#endif
    }
    
    @ViewBuilder
    var pageContent: some View {
        switch currentPage {
            case 0:
                OnboardingPage(
                    title: "Welcome to DiceSplitter",
                    description: "A strategic game of skill, luck, and territory control.",
                    image: "die.face.6.fill"
                )
                .tag(0)
            case 1:
                VStack {
                    OnboardingExplanation(
                        title: "Claim Dice",
                        description: """
                    Tap on dice to claim them for yourself. Each dice shows a number, representing its strength.
                    """,
                        image: "arrow.up.circle.fill",
                        hint: "Dice owned by you are highlighted in your color."
                    )
                    
                    InteractiveDicePreview()
                }
                .tag(1)
            case 2:
                OnboardingExplanation(
                    title: "Grow Your Influence",
                    description: """
                Increase a dice's value to expand your influence. Be strategic: dice with higher values can capture neighboring dice of lower value.
                """,
                    image: "chart.bar.doc.horizontal.fill",
                    hint: "Plan your moves carefully to outwit your opponents!"
                )
                .tag(2)
            case 3:
                OnboardingExplanation(
                    title: "Win the Game",
                    description: """
                The player who dominates the board or scores the highest when no moves are left wins!
                """,
                    image: "crown.fill",
                    hint: "Keep an eye on your score in the player ticker at the top."
                )
                .tag(3)
            case 4:
                PersonalizeOnboarding(
                    mapSize: $mapSize,
                    playerType: $playerType,
                    numberOfPlayers: $numberOfPlayers, aiDifficulty: $aiDifficulty,
                    onComplete: completion
                )
                .tag(4)
            default:
                EmptyView()
        }
    }
}

#Preview {
    OnboardingView(mapSize: .constant(.zero), playerType: .constant(.ai), numberOfPlayers: .constant(3), aiDifficulty: .constant(.easy), completion: {})
}

