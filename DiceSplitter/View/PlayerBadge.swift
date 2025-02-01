
struct PlayerBadge: View {
    let player: Player
    let score: Int
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "person.fill")
                .foregroundColor(player.color)
            
            Text("\(score)")
                .font(.system(.body, design: .rounded, weight: .semibold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 20)
            #if !os(macOS)
                .fill(isActive ? player.color.opacity(0.2) : Color(.secondarySystemBackground))
            #endif
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
            #if !os(macOS)
                .stroke(isActive ? player.color : Color(.separator), lineWidth: 1)
            #endif
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(player.accessibilityName), Score: \(score)")
    }
}