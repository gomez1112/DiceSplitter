//
//  PersonalizePage.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 7/12/25.
//

import SwiftUI

struct PersonalizePage: View {
    @Binding var mapSize: CGSize
    @Binding var playerType: PlayerType
    @Binding var numberOfPlayers: Int
    @Binding var aiDifficulty: AIDifficulty
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Set Up Your Game")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(ColorTheme.primaryText)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Board Size
                    SettingCard(
                        title: "Board Size",
                        icon: "square.grid.3x3.fill",
                        iconColor: ColorTheme.primary
                    ) {
                        VStack(spacing: 16) {
                            HStack {
                                Text("\(Int(mapSize.width))×\(Int(mapSize.height))")
                                    .font(.system(.title, design: .rounded, weight: .bold))
                                    .foregroundStyle(ColorTheme.primaryText)
                                    .contentTransition(.numericText())
                                
                                Spacer()
                                
                                GridPatternPreview(
                                    columns: Int(mapSize.width),
                                    rows: Int(mapSize.height)
                                )
                                .frame(width: 80, height: 80)
                            }
                            
                            DualSlider(
                                widthLabel: "Columns: \(Int(mapSize.width))",
                                heightLabel: "Rows: \(Int(mapSize.height))",
                                width: $mapSize.width,
                                height: $mapSize.height,
                                range: 3...12
                            )
                        }
                    }
                    
                    // Players
                    SettingCard(
                        title: "Players",
                        icon: "person.3.fill",
                        iconColor: ColorTheme.accent
                    ) {
                        VStack(spacing: 20) {
                            HStack(spacing: 12) {
                                ForEach(2...4, id: \.self) { count in
                                    PlayerCountButton(
                                        count: count,
                                        isSelected: numberOfPlayers == count
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                            numberOfPlayers = count
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            
                            HStack {
                                Label("AI Opponent", systemImage: "brain")
                                    .font(.system(.body, design: .rounded, weight: .medium))
                                    .foregroundStyle(ColorTheme.primaryText)
                                
                                Spacer()
                                
                                Toggle("", isOn: Binding(
                                    get: { playerType == .ai },
                                    set: { playerType = $0 ? .ai : .human }
                                ))
                                .toggleStyle(EnhancedToggleStyle())
                            }
                            
                            if playerType == .ai {
                                VStack(alignment: .leading, spacing: 12) {
                                    Label("AI Difficulty", systemImage: "slider.horizontal.3")
                                        .font(.system(.caption, design: .rounded, weight: .medium))
                                        .foregroundStyle(ColorTheme.secondaryText)
                                    
                                    HStack(spacing: 8) {
                                        ForEach(AIDifficulty.allCases, id: \.self) { difficulty in
                                            DifficultyButton(
                                                difficulty: difficulty,
                                                isSelected: aiDifficulty == difficulty
                                            ) {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                                    aiDifficulty = difficulty
                                                }
                                            }
                                        }
                                    }
                                }
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.9).combined(with: .opacity),
                                    removal: .scale(scale: 1.1).combined(with: .opacity)
                                ))
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    PersonalizePage(mapSize: .constant(CGSize(width: 3, height: 3)), playerType: .constant(.human), numberOfPlayers: .constant(2), aiDifficulty: .constant(.hard))
}
