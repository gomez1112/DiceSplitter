//
//  StatisticsView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 6/5/25.
//

import SwiftData
import SwiftUI

struct StatisticsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let stats: Statistics
    @State private var selectedTab = 0
    @State private var showResetConfirmation = false
    @State private var contentOpacity: Double = 0
    @State private var contentScale: CGFloat = 0.95
    
    var body: some View {
        ZStack {
            backgroundView
            ScrollView {
                VStack(spacing: 0) {
                    // Custom header
                    statsHeader
                        .padding(.top, 20)
                        .padding(.horizontal)
                    
                    // Enhanced tab selector
                    TabSelector(selectedTab: $selectedTab)
                        .padding(.horizontal)
                        .padding(.vertical, 16)
                    
                    // Content
                    Group {
                        if selectedTab == 0 {
                            statisticsContent
                        } else {
                            achievementsContent
                        }
                    }
                    .opacity(contentOpacity)
                    .scaleEffect(contentScale)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    contentOpacity = 1
                    contentScale = 1
                }
            }
            .onChange(of: selectedTab) { _, _ in
                withAnimation(.easeOut(duration: 0.2)) {
                    contentOpacity = 0
                    contentScale = 0.95
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        contentOpacity = 1
                        contentScale = 1
                    }
                }
            }
#if os(macOS)
            .frame(minWidth: 600, minHeight: 700)
#endif
        }
        .ignoresSafeArea(edges: .top)
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
    var statsHeader: some View {
        VStack(spacing: 16) {
            // Trophy icon with glow
            ZStack {
                Circle()
                    .fill(ColorTheme.warning.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                
                Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [ColorTheme.warning, ColorTheme.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.pulse)
                    .neonGlow(color: ColorTheme.warning, intensity: 6)
            }
            
            // Player stats summary
            HStack(spacing: 30) {
                QuickStat(
                    value: "\(stats.totalGamesPlayed)",
                    label: String(localized: "games_label"),
                    color: ColorTheme.primary
                )
                
                QuickStat(
                    value: String(format: "%.0f%%", stats.winRate),
                    label: String(localized: "win_rate_label"),
                    color: ColorTheme.success
                )
                
                QuickStat(
                    value: "\(stats.bestWinStreak)",
                    label: String(localized: "best_streak_label"),
                    color: ColorTheme.accent
                )
            }
        }
    }
    
    // MARK: - Statistics Content
    var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Performance Overview with Chart
                StatCard(
                    title: String(localized: "performance_overview"),
                    icon: "chart.line.uptrend.xyaxis",
                    iconColor: ColorTheme.primary
                ) {
                    VStack(spacing: 20) {
                        // Win/Loss/Draw Chart
                        if stats.totalGamesPlayed > 0 {
                            PerformanceChart(
                                wins: stats.totalWins,
                                losses: stats.totalLosses,
                                draws: stats.totalDraws
                            )
                            .frame(height: 200)
                        }
                        
                        // Performance metrics
                        VStack(spacing: 12) {
                            StatRow(
                                icon: "checkmark.circle.fill",
                                label: String(localized: "wins_label"),
                                value: "\(stats.totalWins)",
                                color: ColorTheme.success,
                                progress: Double(stats.totalWins) / Double(max(stats.totalGamesPlayed, 1))
                            )
                            
                            StatRow(
                                icon: "xmark.circle.fill",
                                label: String(localized: "losses_label"),
                                value: "\(stats.totalLosses)",
                                color: ColorTheme.error,
                                progress: Double(stats.totalLosses) / Double(max(stats.totalGamesPlayed, 1))
                            )
                            
                            StatRow(
                                icon: "equal.circle.fill",
                                label: String(localized: "draws_label"),
                                value: "\(stats.totalDraws)",
                                color: ColorTheme.warning,
                                progress: Double(stats.totalDraws) / Double(max(stats.totalGamesPlayed, 1))
                            )
                        }
                    }
                }
                
                // Streaks & Records
                HStack(spacing: 16) {
                    MiniStatCard(
                        title: String(localized: "current_streak"),
                        value: "\(stats.winStreak)",
                        icon: "flame.fill",
                        color: stats.winStreak > 0 ? ColorTheme.accent : ColorTheme.tertiaryText
                    )
                    
                    MiniStatCard(
                        title: String(localized: "total_moves"),
                        value: formatNumber(stats.totalMovesPlayed),
                        icon: "hand.tap.fill",
                        color: ColorTheme.info
                    )
                }
                
                // Difficulty Breakdown
                if stats.totalWins > 0 {
                    StatCard(
                        title: String(localized: "wins_by_difficulty"),
                        icon: "brain",
                        iconColor: ColorTheme.secondary
                    ) {
                        VStack(spacing: 16) {
                            DifficultyProgressBar(
                                difficulty: String(localized: "difficulty_easy"),
                                wins: stats.easyWins,
                                total: stats.totalWins,
                                color: ColorTheme.success
                            )
                            
                            DifficultyProgressBar(
                                difficulty: String(localized: "difficulty_medium"),
                                wins: stats.mediumWins,
                                total: stats.totalWins,
                                color: ColorTheme.warning
                            )
                            
                            DifficultyProgressBar(
                                difficulty: String(localized: "difficulty_hard"),
                                wins: stats.hardWins,
                                total: stats.totalWins,
                                color: ColorTheme.accent
                            )
                            
                            DifficultyProgressBar(
                                difficulty: String(localized: "difficulty_expert"),
                                wins: stats.expertWins,
                                total: stats.totalWins,
                                color: ColorTheme.error
                            )
                        }
                    }
                }
                
                // Records
                StatCard(
                    title: String(localized: "personal_records"),
                    icon: "medal.fill",
                    iconColor: ColorTheme.warning
                ) {
                    VStack(spacing: 16) {
                        // FIXED: Use formattedFastestWin property
                        if let fastestWin = stats.formattedFastestWin {
                            RecordRow(
                                icon: "timer",
                                label: String(localized: "fastest_win"),
                                value: fastestWin,
                                color: ColorTheme.info
                            )
                        }
                        
                        RecordRow(
                            icon: "square.grid.3x3.fill",
                            label: String(localized: "largest_board"),
                            value: String(localized: "tiles_count \(stats.largestBoardConquered)"),
                            color: ColorTheme.primary
                        )
                        
                        if stats.totalGamesPlayed > 0 {
                            RecordRow(
                                icon: "divide.circle.fill",
                                label: String(localized: "average_moves"),
                                value: "\(stats.totalMovesPlayed / stats.totalGamesPlayed)",
                                color: ColorTheme.secondary
                            )
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Achievements Content
    var achievementsContent: some View {
        ScrollView {
            // Achievement progress
            VStack(spacing: 16) {
                let unlockedCount = Achievement.allAchievements.filter { stats.isAchievementUnlocked($0) }.count
                let totalCount = Achievement.allAchievements.count
                
                AchievementProgressCard(
                    unlockedCount: unlockedCount,
                    totalCount: totalCount
                )
                
                // Achievement grid
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
                    ForEach(Achievement.allAchievements) { achievement in
                        AchievementCard(
                            achievement: achievement,
                            isUnlocked: stats.isAchievementUnlocked(achievement)
                        )
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Helper Functions
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

#Preview {
    StatisticsView(stats: Statistics())
}
