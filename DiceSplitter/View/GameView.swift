//
//  GameView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftUI

struct GameView: View {
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
    
    @Environment(Audio.self) private var audio
    let stats: Statistics
    
    var body: some View {
        NavigationStack {
            ZStack {
                MeshGradientView()
                    .opacity(0.1)
                ParticleView()
                    .blendMode(.plusLighter)
                
                VStack(spacing: 0) {
                    // Game Status Bar
                    HStack {
                        PlayerScoreTicker(
                            currentPlayer: game.activePlayer,
                            scores: game.players.map { ($0, game.score(for: $0)) }
                        )
                        
                        Spacer()
                        
                        // AI Thinking Indicator
                        if game.isAIThinking {
                            AIThinkingIndicator()
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    
                    // Game Board
                    ScrollView {
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: game.rows.first?.count ?? 5),
                            spacing: 8
                        ) {
                            ForEach(game.rows.flatMap { $0 }, id: \.id) { dice in
                                Button {
                                    if !game.isPaused {
                                        audio.playSound(.tap)
                                        audio.playHaptic(.light)
                                        game.increment(dice)
                                    }
                                } label: {
                                    DiceView(dice: dice)
                                }
                                .disabled(game.isPaused || game.isAIThinking || game.state != .waiting)
                            }
                        }
                        .padding()
                    }
                    .scrollIndicators(.hidden)
                    .blur(radius: game.isPaused ? 3 : 0)
                    .overlay {
                        if game.isPaused {
                            PauseOverlay(game: game, resumeAction: {
                                game.isPaused = false
                                audio.playSound(.tap)
                            })
                        }
                    }
                    
                    // Game Controls
                    HStack(spacing: 20) {
                        // Undo Button
                        Button {
                            audio.playSound(.move)
                            audio.playHaptic(.medium)
                            game.undo()
                        } label: {
                            Label("Undo", systemImage: "arrow.uturn.backward")
                                .font(.system(.body, design: .rounded))
                        }
                        .buttonStyle(.bordered)
                        .disabled(!game.canUndo)
                        
                        Spacer()
                        
                        // Pause Button
                        Button {
                            audio.playSound(.tap)
                            game.isPaused.toggle()
                        } label: {
                            Label(game.isPaused ? "Resume" : "Pause", systemImage: game.isPaused ? "play.fill" : "pause.fill")
                                .font(.system(.body, design: .rounded))
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
                .navigationTitle("Dice Splitter")
#if !os(macOS)
                .navigationBarTitleDisplayMode(.inline)
#endif
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button {
                                if game.state == .waiting && !game.isGameOver {
                                    showingNewGameConfirmation = true
                                } else {
                                    resetGame()
                                }
                            } label: {
                                Label("New Game", systemImage: "arrow.clockwise")
                            }
                            
                            Button("Settings", systemImage: "gear") {
                                showingSettings = true
                            }
                            
                            Button("Statistics", systemImage: "chart.bar.fill") {
                                showingStatistics = true
                            }
                            
                        } label: {
                            Label("Menu", systemImage: "ellipsis.circle")
                        }
                    }
                }
                .confirmationDialog("Start New Game?", isPresented: $showingNewGameConfirmation) {
                    Button("New Game", role: .destructive) {
                        audio.playSound(.tap)
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
                                // Record statistics
                                stats.recordGameResult(
                                    winner: game.winner,
                                    playerType: playerType,
                                    boardSize: Int(mapSize.width) * Int(mapSize.height),
                                    duration: game.gameDuration,
                                    moves: game.totalMoves,
                                    difficulty: aiDifficulty
                                )
                                
                                if game.winner == game.activePlayer {
                                    audio.playSound(.win)
                                    audio.playHaptic(.success)
                                } else if game.winner == nil {
                                    audio.playSound(.move)
                                } else {
                                    audio.playSound(.lose)
                                    audio.playHaptic(.error)
                                }
                                
                                resetGame()
                            }
                        )
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .achievementUnlocked)) { notification in
            if let achievement = notification.object as? Achievement {
                showingAchievement = achievement
                audio.playSound(.win)
                audio.playHaptic(.success)
            }
        }
        .overlay(alignment: .top) {
            if let achievement = showingAchievement {
                AchievementNotification(achievement: achievement)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showingAchievement = nil
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - AI Thinking Indicator
struct AIThinkingIndicator: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "brain")
                .font(.system(.body, design: .rounded))
                .symbolEffect(.pulse, value: isAnimating)
            
            Text("AI Thinking...")
                .font(.system(.caption, design: .rounded))
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: Capsule())
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Pause Overlay
struct PauseOverlay: View {
    let game: Game
    let resumeAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Game Paused")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                
                VStack(spacing: 16) {
                    Button(action: resumeAction) {
                        Label("Resume", systemImage: "play.fill")
                            .font(.system(.title3, design: .rounded, weight: .semibold))
                            .frame(width: 200)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    // Game Info
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Time:")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(formatTime(game.gameDuration))
                                .monospacedDigit()
                        }
                        
                        HStack {
                            Text("Moves:")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(game.totalMoves)")
                                .monospacedDigit()
                        }
                    }
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.white)
                    .padding()
                    .frame(width: 200)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Achievement Notification
struct AchievementNotification: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: achievement.icon)
                .font(.title2)
                .foregroundStyle(.yellow)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Achievement Unlocked!")
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                
                Text(achievement.name)
                    .font(.system(.body, design: .rounded, weight: .bold))
            }
            
            Spacer()
        }
        .padding()
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 10)
        .padding()
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

