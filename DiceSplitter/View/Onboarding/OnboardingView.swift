//
//  OnboardingView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let completion: () -> Void
    
    var body: some View {
        ZStack {
            MeshGradientView()
            ParticleView()
                .blendMode(.plusLighter)
            
            VStack(spacing: 30) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        title: "Welcome to DiceSplitter",
                        description: "A strategic game of skill, luck, and territory control.",
                        image: "die.face.6.fill"
                    )
                    .tag(0)
                    
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
                    OnboardingExplanation(
                        title: "Grow Your Influence",
                        description: """
                        Increase a dice's value to expand your influence. Be strategic: dice with higher values can capture neighboring dice of lower value.
                        """,
                        image: "chart.bar.doc.horizontal.fill",
                        hint: "Plan your moves carefully to outwit your opponents!"
                    )
                    .tag(2)
                    
                    OnboardingExplanation(
                        title: "Win the Game",
                        description: """
                        The player who dominates the board or scores the highest when no moves are left wins!
                        """,
                        image: "crown.fill",
                        hint: "Keep an eye on your score in the player ticker at the top."
                    )
                    .tag(3)
                    
                    PersonalizeOnboarding(onComplete: completion)
                        .tag(4)
                }
                #if !os(macOS)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                #endif
                .animation(.easeInOut, value: currentPage)
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
                if currentPage == 4 {
                    Button("Get Started") {
                        completion()
                    }
                    .buttonStyle(ScalingButtonStyle())
                    .padding(.horizontal, 30)
                }
            }
            .padding()
        }
        .transition(.opacity)
    }
}

#Preview {
    OnboardingView(completion: {})
}

