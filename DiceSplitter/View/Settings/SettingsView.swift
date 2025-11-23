//
//  SettingsView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("soundEnabled") var soundEnabled = true
    @AppStorage("hapticEnabled") var hapticEnabled = true
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @Binding var mapSize: CGSize
    @Binding var playerType: PlayerType
    @Binding var numberOfPlayers: Int
    @Binding var aiDifficulty: AIDifficulty
    let showingWarning: Bool
    var startGame: () -> Void
    
    @State private var showingResetGameWarning = false
    @State private var audio = Audio()
    @State private var selectedCategory = 0
    
    var body: some View {
#if os(macOS)
        settingsContent
            .frame(minWidth: 500, minHeight: 600)
#else
        settingsContent
            .navigationTitle("Settings")
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
#endif
    }
    var settingsContent: some View {
        ZStack {
            
            backgroundView
            ScrollView {
                VStack(spacing: 30) {
                    // Header with animated icons
                    settingsHeader
                        .padding(.top, 20)
                    
                    // Settings Cards
                    VStack(spacing: 20) {
                        // Board Size Setting
                        SettingCard(
                            title: "Board Size",
                            icon: "square.grid.3x3.fill",
                            iconColor: ColorTheme.primary
                        ) {
                            boardSizeContent
                        }
                        
                        // Players Setting
                        SettingCard(
                            title: "Players",
                            icon: "person.3.fill",
                            iconColor: ColorTheme.accent
                        ) {
                            playersContent
                        }
                        
                        // Audio Settings
                        SettingCard(
                            title: "Audio",
                            icon: "speaker.wave.2.fill",
                            iconColor: ColorTheme.success
                        ) {
                            audioContent
                        }
                        
                        // Tutorial Card
                        SettingCard(
                            title: "Help",
                            icon: "questionmark.circle.fill",
                            iconColor: ColorTheme.info
                        ) {
                            helpContent
                        }
                    }
                    .padding(.horizontal)
                    appVersionFooter
                }
            }
#if os(iOS)
            .scrollDismissesKeyboard(.interactively)
#endif
        }
        .ignoresSafeArea(edges: .top)
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
    // MARK: - Background
    var backgroundView: some View {
        ZStack {
            gradientBackground
            animatedMeshGradient
            particleEffect
            
        }
    }
    @ViewBuilder
    private var particleEffect: some View {
        ParticleField()
            .opacity(0.6)
    }
    private var animatedMeshGradient: some View {
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
    // MARK: - Header
    var settingsHeader: some View {
        VStack(spacing: 20) {
            // Animated dice icons
            HStack(spacing: 20) {
                ForEach(1...3, id: \.self) { i in
                    Image(systemName: "die.face.\(i).fill")
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [ColorTheme.primary, ColorTheme.secondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .rotationEffect(.degrees(i == 2 ? 15 : -15))
                        .scaleEffect(i == 2 ? 1.2 : 1)
                        .floating(delay: Double(i) * 0.2)
                }
            }
            
            Text("Game Configuration")
                .font(.system(.largeTitle, design: .rounded, weight: .black))
                .foregroundStyle(ColorTheme.primaryText)
                .shimmer(duration: 3)
        }
    }
    // MARK: - Board Size Content
    var boardSizeContent: some View {
        VStack(spacing: 20) {
            // Size display with preview
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(Int(mapSize.width))×\(Int(mapSize.height))")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(ColorTheme.primaryText)
                        .contentTransition(.numericText())
                    
                    Text("\(Int(mapSize.width * mapSize.height)) tiles")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                GridPatternPreview(
                    columns: Int(mapSize.width),
                    rows: Int(mapSize.height)
                )
                .frame(width: 100, height: 100)
            }
            
            // Sliders
            VStack(spacing: 24) {
                SliderRow(
                    label: "Columns",
                    value: $mapSize.width,
                    range: 3...12,
                    icon: "arrow.left.and.right"
                )
                
                SliderRow(
                    label: "Rows",
                    value: $mapSize.height,
                    range: 3...12,
                    icon: "arrow.up.and.down"
                )
            }
            
            // Quick presets
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    BoardPresetButton(width: 4, height: 4, label: "Tiny", currentSize: mapSize) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            mapSize = CGSize(width: 4, height: 4)
                        }
                    }
                    BoardPresetButton(width: 6, height: 6, label: "Small", currentSize: mapSize) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            mapSize = CGSize(width: 6, height: 6)
                        }
                    }
                    BoardPresetButton(width: 8, height: 8, label: "Medium", currentSize: mapSize) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            mapSize = CGSize(width: 8, height: 8)
                        }
                    }
                    BoardPresetButton(width: 10, height: 10, label: "Large", currentSize: mapSize) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            mapSize = CGSize(width: 10, height: 10)
                        }
                    }
                    BoardPresetButton(width: 12, height: 12, label: "Huge", currentSize: mapSize) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            mapSize = CGSize(width: 12, height: 12)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Players Content
    var playersContent: some View {
        VStack(spacing: 24) {
            // Player count selector
            HStack(spacing: 16) {
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
            
            // AI Toggle
            VStack(spacing: 16) {
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
                
                // AI Difficulty (animated appearance)
                if playerType == .ai {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("AI Difficulty", systemImage: "slider.horizontal.3")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
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
    
    // MARK: - Audio Content
    var audioContent: some View {
        VStack(spacing: 20) {
            HStack {
                Label("Sound Effects", systemImage: "speaker.wave.2.fill")
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundStyle(ColorTheme.primaryText)
                
                Spacer()
                
                Toggle("", isOn: $soundEnabled)
                    .toggleStyle(EnhancedToggleStyle())
            }
            
#if os(iOS)
            HStack {
                Label("Haptic Feedback", systemImage: "iphone.radiowaves.left.and.right")
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundStyle(ColorTheme.primaryText)
                
                Spacer()
                
                Toggle("", isOn: $hapticEnabled)
                    .toggleStyle(EnhancedToggleStyle())
            }
#endif
        }
    }
    
    // MARK: - Help Content
    var helpContent: some View {
        Button {
            hasCompletedOnboarding = false
            dismiss()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Show Tutorial")
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(ColorTheme.primaryText)
                    
                    Text("Learn how to play Dice Splitter")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundStyle(ColorTheme.info)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    var appVersionFooter: some View {
        VStack(spacing: 8) {
            Text(String(localized: "app_version \(Bundle.main.appVersion)"))
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(ColorTheme.tertiaryText)
            
            Text(String(localized: "build_number \(Bundle.main.buildNumber)"))
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(ColorTheme.tertiaryText.opacity(0.7))
        }
        .padding(.top, 20)
    }
}


#Preview {
    SettingsView(mapSize: .constant(.init(width: 8, height: 8)), playerType: .constant(.human), numberOfPlayers: .constant(3), aiDifficulty: .constant(.medium), showingWarning: true, startGame: {  })
}


