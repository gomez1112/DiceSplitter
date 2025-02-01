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
                            )}
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


// Add this new modifier at the bottom of your file
struct SettingsCardContentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.primary)
            .padding(.horizontal, 8)
    }
}

