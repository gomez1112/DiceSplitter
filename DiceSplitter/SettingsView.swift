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
        VStack(spacing: 20) {
            Text("Game Settings")
                .font(.system(size: 34, weight: .bold, design: .rounded))
            VStack(spacing: 15) {
                Stepper("Map Width: \(Int(mapSize.width))", value: $mapSize.width, in: 3...20)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                Stepper("Map Height: \(Int(mapSize.height))", value: $mapSize.height, in: 3...20)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                Picker("Second Player Type", selection: $playerType) {
                    Text("AI")
                        .tag(PlayerType.ai)
                    Text("Human")
                        .tag(PlayerType.human)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                Stepper("Number of Players: \(numberOfPlayers)", value: $numberOfPlayers, in: 2...4)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 15))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
            
            Button(action: startGame) {
                Text("Start Game")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            }
            .padding(.horizontal, 40)
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

#Preview {
    SettingsView(mapSize: .constant(.init(width: 8, height: 8)), playerType: .constant(.human), numberOfPlayers: .constant(3), startGame: {  })
}
