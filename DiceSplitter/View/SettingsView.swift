//
//  SettingsView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @Binding var mapSize: CGSize
    @Binding var playerType: PlayerType
    @Binding var numberOfPlayers: Int
    @Binding var aiDifficulty: AIDifficulty
    let showingWarning: Bool
    var startGame: () -> Void
    
    @State private var showingResetGameWarning = false
    @State private var audio = Audio()
    
    var body: some View {
#if os(macOS)
        settingsContent
            .frame(minWidth: 500, minHeight: 600)
#else
        NavigationStack {
            settingsContent
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
        }
#endif
    }
    
    var settingsContent: some View {
        ZStack {
            MeshGradientView()
            ParticleView()
                .blendMode(.plusLighter)
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            ForEach(1...3, id: \.self) { i in
                                Image(systemName: "die.face.\(i).fill")
                                    .font(.largeTitle)
                                    .rotationEffect(.degrees(i == 2 ? 15 : -15))
                                    .scaleEffect(i == 2 ? 1.2 : 1)
                            }
                        }
                        .foregroundStyle(.white)
                        
                        Text("Game Configuration")
                            .font(.system(.largeTitle, design: .rounded, weight: .black))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    
                    VStack(spacing: 20) {
                        // Board Size Setting
                        SettingCard(title: "Board Size", icon: "square.grid.3x3.fill") {
                            HStack {
                                Text("\(Int(mapSize.width))x\(Int(mapSize.height))")
                                    .font(.title3.monospacedDigit())
                                    .bold()
                                
                                Spacer()
                                
                                GridPatternPreview(columns: Int(mapSize.width), rows: Int(mapSize.height))
                                    .frame(width: 80, height: 80)
                            }
                            .padding(.vertical, 8)
                            
                            DualSlider(
                                widthLabel: "Columns: \(Int(mapSize.width))",
                                heightLabel: "Rows: \(Int(mapSize.height))",
                                width: $mapSize.width,
                                height: $mapSize.height,
                                range: 3...12 // Limited to reasonable size
                            )
                        }
                        
                        // Players Setting
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
                            .padding(.vertical, 8)
                            
                            Toggle("AI Opponent", isOn: Binding(
                                get: { playerType == .ai },
                                set: { playerType = $0 ? .ai : .human }
                            ))
                            .toggleStyle(.switch)
                            
                            if playerType == .ai {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("AI Difficulty")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    
                                    Picker("Difficulty", selection: $aiDifficulty) {
                                        ForEach(AIDifficulty.allCases, id: \.self) { difficulty in
                                            Text(difficulty.rawValue).tag(difficulty)
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                }
                                .padding(.top, 8)
                            }
                        }
                        
                        // Sound Settings
                        SettingCard(title: "Audio", icon: "speaker.wave.2.fill") {
                            Toggle("Sound Effects", isOn: $audio.soundEnabled)
                                .toggleStyle(.switch)
                            
#if os(iOS)
                            Toggle("Haptic Feedback", isOn: $audio.hapticEnabled)
                                .toggleStyle(.switch)
#endif
                        }
                    }
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        Button {
                            if showingWarning {
                                showingResetGameWarning = true
                            } else {
                                startGame()
                                dismiss()
                            }
                        } label: {
                            HStack {
                                Text("Start Battle")
                                Image(systemName: "play.fill")
                            }
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.blue)
                                    .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
                            )
                        }
                        .buttonStyle(ScalingButtonStyle())
                        
                        Button {
                            hasCompletedOnboarding = false
                            dismiss()
                        } label: {
                            HStack {
                                Text("Show Tutorial")
                                Image(systemName: "questionmark.circle.fill")
                            }
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                            )
                        }
                        .buttonStyle(ScalingButtonStyle())
                        
#if os(macOS)
                        Button("Cancel") {
                            dismiss()
                        }
                        .buttonStyle(.bordered)
#endif
                    }
                }
                .padding()
            }
#if os(iOS)
            .scrollDismissesKeyboard(.interactively)
#endif
        }
        .confirmationDialog("Start New Game?", isPresented: $showingResetGameWarning) {
            Button("Start New Game", role: .destructive) {
                startGame()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Your current game progress will be lost.")
        }
    }
}

struct ScalingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}


#Preview {
    SettingsView(mapSize: .constant(.init(width: 8, height: 8)), playerType: .constant(.human), numberOfPlayers: .constant(3), aiDifficulty: .constant(.medium), showingWarning: true, startGame: {  })
}


