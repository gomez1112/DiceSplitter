//
//  TutorialView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/17/25.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    
    let tutorialSteps = [
        TutorialStep(
            title: "Welcome to DiceSplitter",
            description: "A strategic dice game where you compete for territory control.",
            image: "die.face.6.fill"
        ),
        TutorialStep(
            title: "Claim Dice",
            description: "Tap on neutral (gray) dice to claim them for your color.",
            image: "hand.tap.fill"
        ),
        TutorialStep(
            title: "Build Strength",
            description: "Each tap increases the dice value by one. Higher values mean more power!",
            image: "plus.circle.fill"
        ),
        TutorialStep(
            title: "Chain Reactions",
            description: "When a dice value exceeds its neighbor count, it explodes and spreads to adjacent dice.",
            image: "burst.fill"
        ),
        TutorialStep(
            title: "Win the Game",
            description: "Control all dice on the board or have the highest score when no moves remain.",
            image: "trophy.fill"
        )
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress indicator
                ProgressView(value: Double(currentStep + 1), total: Double(tutorialSteps.count))
                    .progressViewStyle(.linear)
                    .tint(.accentColor)
                
                TabView(selection: $currentStep) {
                    ForEach(Array(tutorialSteps.enumerated()), id: \.offset) { index, step in
                        VStack(spacing: 32) {
                            Spacer()
                            
                            Image(systemName: step.image)
                                .font(.system(size: 80))
                                .tint(.accentColor)
                                .symbolEffect(.bounce, value: currentStep)
                            
                            VStack(spacing: 16) {
                                Text(step.title)
                                    .font(.title.bold())
                                
                                Text(step.description)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
//                            
                            Spacer()
                            
                            if index == tutorialSteps.count - 1 {
                                Button("Start Playing") {
                                    dismiss()
                                }
                                .font(.headline)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .clipShape(Capsule())
                            }
                        }
                        .tag(index)
                        .padding()
                    }
                }
                #if !os(macOS)
                .tabViewStyle(.page(indexDisplayMode: .never))
                #endif
            }
            .navigationTitle("How to Play")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Skip") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TutorialView()
}

struct TutorialStep {
    let title: String
    let description: String
    let image: String
}
