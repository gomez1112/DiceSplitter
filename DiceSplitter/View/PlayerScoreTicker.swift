struct PlayerScoreTicker: View {
    let currentPlayer: Player
    let scores: [(player: Player, score: Int)]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(scores, id: \.player) { player, score in
                    PlayerBadge(
                        player: player,
                        score: score,
                        isActive: player == currentPlayer
                    )
                }
            }
            .padding(.vertical, 8)
        }
    }
}