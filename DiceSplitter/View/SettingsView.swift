//
//  SettingsView.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import SwiftUI

struct SettingsView: View {
    @Binding var mapSize: CGSize
    @Binding var playerType: PlayerType
    @Binding var numberOfPlayers: Int
    var startGame: () -> Void
    
    
    var body: some View {
        ZStack {
            MeshGradientView()
            ParticleView()
                .blendMode(.plusLighter)
            ScrollView {
                VStack(spacing: 30) {
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
                    VStack(spacing: 20) {
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
                                widthLabel: "Columns",
                                heightLabel: "Rows",
                                width: $mapSize.width,
                                height: $mapSize.height,
                                range: 3...20
                            )
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
                                
                                HStack {
                                    Text("AI Opponent")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { playerType == .ai },
                                        set: { playerType = $0 ? .ai : .human }
                                    ))
                                    .toggleStyle(DynamicToggleStyle())
                                }
                            }
                        }
                        
                    }
                    Button(action: startGame) {
                        HStack {
                            Text("Start Battle")
                            Image(systemName: "play.fill")
                        }
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .buttonStyle(ScalingButtonStyle())
                }
                .padding()
            }
        }
    }
}


struct SettingCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder var content:  () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.title3)
                Text(title)
                    .font(.headline.bold())
                Spacer()
            }
            
            content()
             .settingsCardContentStyle()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

struct PlayerCountButton: View {
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: count == 4 ? "person.badge.plus" : "person.\(count)")
                    .font(.title2)
                    .symbolVariant(isSelected ? .fill : .none)
                
                Text("\(count)")
                    .font(.callout.bold())
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .blue.opacity(0.2) : .clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .blue : .gray.opacity(0.3), lineWidth: 2)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct GridPatternPreview: View {
    let columns: Int
    let rows: Int
    
    var body: some View {
        GeometryReader { geo in
            let cellSize = min(geo.size.width / CGFloat(columns), geo.size.height / CGFloat(rows))
            
            Canvas { context, size in
                for column in 0..<columns {
                    for row in 0..<rows {
                        let rect = CGRect(
                            x: CGFloat(column) * cellSize,
                            y: CGFloat(row) * cellSize,
                            width: cellSize - 2,
                            height: cellSize - 2
                        )
                        
                        context.fill(
                            Path(roundedRect: rect, cornerRadius: 4),
                            with: .color(.blue.opacity(0.2))
                        )
                    }
                }
            }
        }
    }
}
struct ScalingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

struct DynamicToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            RoundedRectangle(cornerRadius: 20)
                .fill(configuration.isOn ? Color.blue : Color.gray.opacity(0.3))
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(.white)
                        .shadow(radius: 2)
                        .padding(3)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .animation(.spring(), value: configuration.isOn)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

#Preview {
    SettingsView(mapSize: .constant(.init(width: 8, height: 8)), playerType: .constant(.human), numberOfPlayers: .constant(3), startGame: {  })
}

struct ParticleView: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(.white.opacity(0.05))
                        .frame(width: particle.size, height: particle.size)
                        .offset(x: particle.x, y: particle.y)
                }
            }
            .onAppear {
                generateParticles(in: geometry.size)
            }
        }
        .ignoresSafeArea() // Ensures particles extend beyond safe areas if needed
    }
    
    private func generateParticles(in size: CGSize) {
        particles = (0..<50).map { _ in
            Particle(
                x: CGFloat.random(in: -size.width / 2...size.width / 2),
                y: CGFloat.random(in: -size.height / 2...size.height / 2),
                size: CGFloat.random(in: 20...100),
                speed: CGFloat.random(in: 0.5...2)
            )
        }
    }
}


struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let speed: CGFloat
}
// Add this new modifier at the bottom of your file
struct SettingsCardContentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.primary)
            .padding(.horizontal, 8)
    }
}

extension View {
    func settingsCardContentStyle() -> some View {
        modifier(SettingsCardContentModifier())
    }
}
struct DualSlider: View {
    let widthLabel: String
    let heightLabel: String
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    let range: ClosedRange<CGFloat>
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text(widthLabel)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Slider(value: $width, in: range)
                    .accentColor(.blue)
            }
            
            VStack(alignment: .leading) {
                Text(heightLabel)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Slider(value: $height, in: range)
                    .accentColor(.blue)
            }
        }
    }
}
