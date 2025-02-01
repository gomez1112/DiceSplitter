struct PlayerChip: View {
    let player: Player
    let score: Int
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(player.color)
                .frame(width: 16, height: 16)
            
            Text("\(score)")
                .font(.system(.body, design: .rounded, weight: .bold))
                .contentTransition(.numericText())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            if isActive {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(player.color.opacity(0.2))
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(player.color.opacity(0.3), lineWidth: 1)
        }
        .animation(.bouncy, value: isActive)
    }
}