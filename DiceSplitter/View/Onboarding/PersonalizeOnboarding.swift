struct PersonalizeOnboarding: View {
    @State private var mapSize = CGSize(width: 5, height: 5)
    @State private var playerType: PlayerType = .human
    @State private var numberOfPlayers = 2
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Set Up Your Game")
                .font(.title.bold())
                .foregroundColor(.white)
            
            SettingCard(title: "Board Size", icon: "square.grid.3x3.fill") {
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