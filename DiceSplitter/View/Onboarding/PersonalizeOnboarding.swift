//
//  PersonalizeOnboarding.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/27/25.
//

import SwiftUI

struct PersonalizeOnboarding: View {
    @Binding var mapSize: CGSize
    @Binding var playerType: PlayerType
    @Binding var numberOfPlayers: Int
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Set Up Your Game")
                .font(.title.bold())
                .foregroundColor(.white)
            
            SettingCard(title: "Board Size", icon: "square.grid.3x3.fill") {
                HStack {
                    Text("\(Int(mapSize.width))x\(Int(mapSize.height))")
                        .font(.title3.monospacedDigit())
                        .bold()
                    Spacer()
                    GridPatternPreview(columns: Int(mapSize.width), rows: Int(mapSize.height))
                        .frame(width: 80, height: 80)
                }
                DualSlider(
                    widthLabel: "Columns",
                    heightLabel: "Rows",
                    width: $mapSize.width,
                    height: $mapSize.height,
                    range: 3...20
                )
                
            }
            
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
                
                Toggle("AI Opponent", isOn: Binding(
                    get: { playerType == .ai },
                    set: { playerType = $0 ? .ai : .human }
                ))
                .toggleStyle(DynamicToggleStyle())
            }
            
            Button("Finish Setup") {
                onComplete()
            }
            .buttonStyle(ScalingButtonStyle())
        }
    }
}

#Preview {
    PersonalizeOnboarding(mapSize: .constant(.zero), playerType: .constant(.ai), numberOfPlayers: .constant(3), onComplete: {})
}
