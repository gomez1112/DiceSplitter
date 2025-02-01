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
struct InteractiveDicePreview: View {
    @State private var dice = Dice(row: 0, column: 0, neighbors: 3)
    
    var body: some View {
        VStack(spacing: 20) {
            DiceView(dice: dice)
                .frame(width: 100, height: 100)
                .onTapGesture {
                    dice.owner = Player.green
                    dice.value += 1
                }
            
            Text("Tap the dice to claim it and increase its value!")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
        }
    }
}


struct OnboardingPage: View {
    let title: String
    let description: String
    let image: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 150)
                .foregroundStyle(.white)
            
            Text(title)
                .font(.title.bold())
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .foregroundColor(.white)
    }
}
struct OnboardingExplanation: View {
    let title: String
    let description: String
    let image: String
    let hint: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 150)
                .foregroundStyle(.blue)
            
            Text(title)
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
            
            Text(hint)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
                .italic()
        }
    }
}


struct PersonalizeOnboarding: View {
    @State private var mapSize = CGSize(width: 5, height: 5)
    @State private var playerType: PlayerType = .human
    @State private var numberOfPlayers = 2
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Set Up Your Game")
                .font(.title.bold())
                .foregroundColor(.white)
            
            SettingCard(title: "Board Size", icon: "square.grid.3x3.fill") {
                DualSlider(
                    widthLabel: "Columns",
                    heightLabel: "Rows",
                    width: $mapSize.width,
                    height: $mapSize.height,
                    range: 3...20
                )
            }
            
            SettingCard(title: "Players", icon: "person.3.fill") {
                HStack {
                    ForEach(2...4, id: \.self) { count in
                        PlayerCountButton(
                            count: count,
                            isSelected: numberOfPlayers == count
                        ) {
                            numberOfPlayers = count
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                Toggle("AI Opponent", isOn: Binding(
                    get: { playerType == .ai },
                    set: { playerType = $0 ? .ai : .human }
                ))
                .toggleStyle(DynamicToggleStyle())
            }
            
            Button("Finish Setup") {
                onComplete()
            }
            .buttonStyle(ScalingButtonStyle())
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardingView(completion: {})
}

