//
//  GameView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftData
import SwiftUI

struct GameView: View {
    @AppStorage("soundEnabled") var soundEnabled = true
    @AppStorage("hapticEnabled") var hapticEnabled = true
    
    @Environment(\.modelContext) private var modelContext
    
    let game: Game
    
    @State private var showingSettings = false
    @State private var showingNewGameConfirmation = false
    @State private var showingPauseMenu = false
    @State private var showingAchievement: Achievement?
    @State private var showingStatistics = false
    
    @Binding var mapSize: CGSize
    @Binding var playerType: PlayerType
    @Binding var numberOfPlayers: Int
    @Binding var aiDifficulty: AIDifficulty
    
    let resetGame: () -> Void
    let stats: Statistics
    
    @Environment(Audio.self) private var audio

    
    
    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    // Enhanced background
                    gameBackground
                    
                    VStack(spacing: 0) {
                        // Enhanced Game Status Bar
                        HStack {
                            CurrentPlayerIndicator(player: game.activePlayer)
                            Spacer()
                            ScoreDisplay(players: game.players, scores: game.players.map { game.score(for: $0)})
                        }
                        .padding()
                        
                        // Game Board with enhanced visuals
                        GeometryReader { geometry in
                            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                                gameBoard
                                    .padding(20)
                                    .frame(
                                        minWidth: geometry.size.width,
                                        minHeight: geometry.size.height
                                    )
                            }
                            .scrollBounceBehavior(.basedOnSize)
                        }
                        .blur(radius: game.isPaused ? 10 : 0)
                        .scaleEffect(game.isPaused ? 0.95 : 1)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: game.isPaused)
                        .overlay {
                            if game.isPaused {
                                PauseOverlay(game: game, resumeAction: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        game.isPaused = false
                                        audio.playSound(soundEnabled, .tap)
                                        audio.playHaptic(hapticEnabled, .light)
                                    }
                                })
                            }
                        }
                        HStack {
                            Button {
                                audio.playSound(soundEnabled, .tap)
                                showingPauseMenu = true
                            } label: {
                                Image(systemName: "pause.fill")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            Spacer()
                            if game.isAIThinking {
                                AIThinkingIndicator()
                                    .transition(.asymmetric(
                                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                                        removal: .scale(scale: 1.2).combined(with: .opacity)
                                    ))
                            }
                        }
                        .padding()
                        Spacer()
                    }
                    .navigationTitle("")
                    #if !os(macOS)
                    .navigationBarTitleDisplayMode(.inline)
                    #endif
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Dice Splitter")
                                .font(.system(.title3, design: .rounded, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [ColorTheme.primary, ColorTheme.secondary],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }
                        
                        ToolbarItem(placement: .primaryAction) {
                            Menu {
                                Button {
                                    audio.playSound(soundEnabled, .tap)
                                    if game.state == .waiting && !game.isGameOver {
                                        showingNewGameConfirmation = true
                                    } else {
                                        resetGame()
                                    }
                                } label: {
                                    Label("New Game", systemImage: "arrow.clockwise")
                                }
                                
                                Button {
                                    audio.playSound(soundEnabled, .tap)
                                    showingSettings = true
                                } label: {
                                    Label("Settings", systemImage: "gear")
                                }
                                
                                Button {
                                    audio.playSound(soundEnabled, .tap)
                                    showingStatistics = true
                                } label: {
                                    Label("Statistics", systemImage: "chart.bar.fill")
                                }
                                
                            } label: {
                                Image(systemName: "ellipsis.circle.fill")
                                    .font(.title3)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(ColorTheme.primary)
                            }
                        }
                    }
                    .confirmationDialog("Start New Game?", isPresented: $showingNewGameConfirmation) {
                        Button("New Game", role: .destructive) {
                            audio.playSound(soundEnabled, .tap)
                            resetGame()
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Your current game progress will be lost.")
                    }
                    .sheet(isPresented: $showingSettings) {
                        SettingsView(
                            mapSize: $mapSize,
                            playerType: $playerType,
                            numberOfPlayers: $numberOfPlayers,
                            aiDifficulty: $aiDifficulty,
                            showingWarning: game.state != .waiting && !game.isGameOver
                        ) {
                            resetGame()
                        }
                    }
                    .sheet(isPresented: $showingStatistics) {
                        StatisticsView(stats: stats)
                    }
                    .overlay {
                        if game.isGameOver {
                            GameOverOverlay(
                                winner: game.winner,
                                winnerScore: game.winner.map { game.score(for: $0)} ?? 0,
                                mapSize: $mapSize,
                                playerType: $playerType,
                                numberOfPlayers: $numberOfPlayers,
                                aiDifficulty: $aiDifficulty,
                                reset: {
                                    handleGameOver()
                                }
                            )
                        }
                    }
                }
            }
        .onReceive(NotificationCenter.default.publisher(for: .achievementUnlocked)) { notification in
            if let achievement = notification.object as? Achievement {
                showingAchievement = achievement
                audio.playSound(soundEnabled, .win)
                audio.playHaptic(hapticEnabled, .success)
            }
        }
        .overlay(alignment: .top) {
            if let achievement = showingAchievement {
                AchievementNotification(achievement: achievement)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .scale(scale: 0.5).combined(with: .opacity)
                    ))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                showingAchievement = nil
                            }
                        }
                    }
            }
        }
    }
    
    // MARK: - View Components
    
    var gameBackground: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    ColorTheme.background,
                    ColorTheme.secondaryBackground
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Enhanced mesh gradient
            MeshGradientView()
                .opacity(0.15)
            
            // Particle effect
            ParticleView()
                .blendMode(.plusLighter)
                .opacity(0.5)
        }
    }
    
    var gameBoard: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: game.rows.first?.count ?? 5),
            spacing: 12
        ) {
            ForEach(game.rows.flatMap { $0 }, id: \.id) { dice in
                Button {
                    if !game.isPaused && !game.isAIThinking && game.state == .waiting {
                        audio.playSound(soundEnabled, .tap)
                        audio.playHaptic(hapticEnabled, .light)
                        
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            game.increment(dice)
                        }
                    }
                } label: {
                    DiceView(dice: dice)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.8).combined(with: .opacity),
                            removal: .scale(scale: 1.2).combined(with: .opacity)
                        ))
                }
                .buttonStyle(DiceButtonStyle())
                .disabled(game.isPaused || game.isAIThinking || game.state != .waiting)
            }
        }
    }
    
    private func handleGameOver() {
        // Record statistics
        stats.recordGameResult(
            winner: game.winner,
            playerType: playerType,
            boardSize: Int(mapSize.width) * Int(mapSize.height),
            duration: game.gameDuration,
            moves: game.totalMoves,
            difficulty: aiDifficulty
        )
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save statistics: \(error)")
        }
        
        // Play appropriate sound
        if game.winner == game.activePlayer {
            audio.playSound(soundEnabled, .win)
            audio.playHaptic(hapticEnabled, .success)
        } else if game.winner == nil {
            audio.playSound(soundEnabled, .move)
        } else {
            audio.playSound(soundEnabled, .lose)
            audio.playHaptic(hapticEnabled, .error)
        }
        
        resetGame()
    }
}

#Preview {
    GameView(
        game: Game(rows: 4, columns: 4, playerType: .ai, numberOfPlayers: 3),
        mapSize: .constant(CGSize(width: 4, height: 4)),
        playerType: .constant(.ai),
        numberOfPlayers: .constant(3),
        aiDifficulty: .constant(.medium),
        resetGame: {}, stats: Statistics()
    )
    .environment(Audio())
}

