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
    
    var body: some View {
        NavigationStack {
            ZStack {
                MeshGradientView()
                    .opacity(0.1)
                
                VStack(spacing: 0) {
                    // Tab Selection
                    Picker("View", selection: $selectedTab) {
                        Text("Statistics").tag(0)
                        Text("Achievements").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    if selectedTab == 0 {
                        statisticsContent
                    } else {
                        achievementsContent
                    }
                }
            }
            .navigationTitle("Player Stats")
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .destructiveAction) {
                    Menu {
                        Button("Reset Statistics", role: .destructive) {
                            stats.resetStatistics()
                            try? modelContext.save()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
#if os(macOS)
        .frame(minWidth: 500, minHeight: 600)
#endif
    }
    
    var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Overview Card
                StatCard(title: "Overview", icon: "chart.line.uptrend.xyaxis") {
                    StatRow(label: "Games Played", value: "\(stats.totalGamesPlayed)")
                    StatRow(label: "Total Moves", value: "\(stats.totalMovesPlayed)")
                    StatRow(label: "Win Rate", value: String(format: "%.1f%%", stats.winRate))
                }
                
                // Performance Card
                StatCard(title: "Performance", icon: "trophy.fill") {
                    StatRow(label: "Wins", value: "\(stats.totalWins)", color: .green)
                    StatRow(label: "Losses", value: "\(stats.totalLosses)", color: .red)
                    StatRow(label: "Draws", value: "\(stats.totalDraws)", color: .orange)
                    Divider()
                    StatRow(label: "Current Streak", value: "\(stats.winStreak)")
                    StatRow(label: "Best Streak", value: "\(stats.bestWinStreak)")
                }
                
                // Difficulty Breakdown
                if stats.totalWins > 0 {
                    StatCard(title: "Wins by Difficulty", icon: "brain") {
                        DifficultyBar(label: "Easy", wins: stats.easyWins, total: stats.totalWins, color: .green)
                        DifficultyBar(label: "Medium", wins: stats.mediumWins, total: stats.totalWins, color: .yellow)
                        DifficultyBar(label: "Hard", wins: stats.hardWins, total: stats.totalWins, color: .orange)
                        DifficultyBar(label: "Expert", wins: stats.expertWins, total: stats.totalWins, color: .red)
                    }
                }
                
                // Records Card
                StatCard(title: "Records", icon: "medal.fill") {
                    if stats.fastestWin < 999999.0 {
                        StatRow(label: "Fastest Win", value: formatTime(stats.fastestWin))
                    }
                    StatRow(label: "Largest Board", value: "\(stats.largestBoardConquered) tiles")
                }
            }
            .padding()
        }
    }
    
    var achievementsContent: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                ForEach(Achievement.allAchievements) { achievement in
                    AchievementCard(
                        achievement: achievement,
                        isUnlocked: stats.isAchievementUnlocked(achievement)
                    )
                }
            }
            .padding()
        }
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Supporting Views

struct StatCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.blue)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            
            content()
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct StatRow: View {
    let label: String
    let value: String
    var color: Color = .primary
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(.body, design: .rounded, weight: .semibold))
                .foregroundStyle(color)
        }
    }
}

struct DifficultyBar: View {
    let label: String
    let wins: Int
    let total: Int
    let color: Color
    
    var progress: Double {
        guard total > 0 else { return 0 }
        return Double(wins) / Double(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.caption)
                Spacer()
                Text("\(wins)")
                    .font(.caption.monospacedDigit())
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: achievement.icon)
                .font(.largeTitle)
                .foregroundStyle(isUnlocked ? .yellow : .gray)
                .symbolEffect(.bounce, value: isUnlocked)
            
            Text(achievement.name)
                .font(.caption.bold())
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(achievement.description)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isUnlocked ? Color.yellow.opacity(0.1) : Color.gray.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isUnlocked ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
        )
        .opacity(isUnlocked ? 1 : 0.6)
    }
}


#Preview {
    StatisticsView(stats: Statistics())
}
