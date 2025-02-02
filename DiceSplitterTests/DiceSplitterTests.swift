//
//  DiceSplitterTests.swift
//  DiceSplitterTests
//
//  Created by Gerard Gomez on 1/26/25.
//

import Testing
@testable import DiceSplitter

@MainActor
struct DiceSplitterTests {
    
    // Parameterized test for grid initialization with different sizes
    @Test("Grid initialization with size", arguments: [
        (3, 3),  // Small grid
        (5, 5),  // Medium grid
        (8, 8)   // Large grid
    ])
    func initialGridSetup(rows: Int, columns: Int) {
        let game = Game(rows: rows, columns: columns, playerType: .human, numberOfPlayers: 2)
        
        // Verify grid dimensions
        #expect(game.rows.count == rows)
        for row in game.rows {
            #expect(row.count == columns)
        }
    }
    
    // Parameterized test for neighbor calculations
    @Test("Neighbor count calculations", arguments: [
        // (row, column, totalRows, totalColumns, expectedNeighbors)
        (0, 0, 5, 5, 2),  // Top-left corner
        (0, 2, 5, 5, 3),  // Top edge
        (2, 2, 5, 5, 4),  // Center
        (4, 4, 5, 5, 2)   // Bottom-right corner
    ])
    func neighborCalculations(row: Int, col: Int, totalRows: Int, totalColumns: Int, expected: Int) {
        let game = Game(rows: totalRows, columns: totalColumns, playerType: .human, numberOfPlayers: 2)
        let dice = game.rows[row][col]
        #expect(dice.neighbors == expected)
    }
    
    @Test
    func initialScores() {
        let game = Game(rows: 3, columns: 3, playerType: .human, numberOfPlayers: 2)
        
        for player in game.players {
            #expect(game.score(for: player) == 0, "Player \(player.displayName) should start with 0.")
        }
    }
    
    @Test func incrementDice() async throws {
        // Given: A 3x3 game.
        let game = Game(rows: 3, columns: 3, playerType: .human, numberOfPlayers: 2)
        // Select the center dice.
        let dice = game.rows[1][1]
        let activePlayer = game.activePlayer
        
        // Verify initial state.
        #expect(dice.value == 1, "Initial dice value should be 1")
        #expect(dice.owner == Player.none, "Initial dice owner should be .none")
        
        // When: The active player increments the dice.
        game.increment(dice)
        
        // Because the Game model triggers a chain reaction using async dispatch,
        // wait briefly to let the changes finish.
       // try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Then: The dice's value should have increased (without explosion) and its owner set.
        #expect(dice.value == 2, "After increment, dice value should be 2")
        #expect(dice.owner == activePlayer, "After increment, dice owner should be the active player")
    }
    
    @Test
    func gameOverWhenAllDiceOwnedByOnePlayer() {
        // Given: A 3x3 game.
        let game = Game(rows: 3, columns: 3, playerType: .human, numberOfPlayers: 2)
        // Choose the first player as the winner.
        let winningPlayer = game.players.first!
        
        // Simulate that every dice is owned by the winning player.
        for row in game.rows {
            for dice in row {
                dice.owner = winningPlayer
            }
        }
        
        // Then: The game should be over and the winning player identified.
        #expect(game.isGameOver == true, "Game should be over when all dice are owned by one player")
        #expect(game.winner == winningPlayer, "The winning player should be \(winningPlayer.displayName)")
    }
    
    @Test
    func gameReset() {
        // Given: A 3x3 game.
        let game = Game(rows: 3, columns: 3, playerType: .human, numberOfPlayers: 2)
        
        // Change the state of one dice.
        game.rows[0][0].owner = .red
        game.rows[0][0].value = 5
        
        // When: Resetting the game with a 4x4 board and new settings.
        game.reset(rows: 4, columns: 4, playerType: .ai, numberOfPlayers: 3)
        
        // Then: The game board should now be 4x4 with each dice reset to initial values.
        #expect(game.rows.count == 4, "After reset, game should have 4 rows")
        for row in game.rows {
            #expect(row.count == 4, "After reset, each row should have 4 dice")
            for dice in row {
                #expect(dice.owner == Player.none, "After reset, dice owner should be .none")
                #expect(dice.value == 1, "After reset, dice value should be 1")
            }
        }
        // And: The players array and active player should be updated.
        #expect(game.players.count == 3, "After reset, game should have 3 players")
        #expect(game.activePlayer == game.players.first, "After reset, the active player should be the first in the players list")
    }
    
    @Test
    func gameOverNoValidMoves() async {
        let game = Game(rows: 2, columns: 2, playerType: .human, numberOfPlayers: 2)
        
        // Set each die's value to exceed its neighbors.
        // Then, assign two dice to .green and two dice to .red deterministically.
        for (i, row) in game.rows.enumerated() {
            for (j, die) in row.enumerated() {
                die.value = die.neighbors + 1
                // Use a simple pattern to assign owners:
                // For example, if the sum of the row and column indices is even, assign .green; otherwise, .red.
                die.owner = (i + j) % 2 == 0 ? .green : .red
            }
        }
        
        #expect(game.isGameOver == true)
        #expect(game.winner == nil) // Tie scenario
    }
    
    @Test
    func scoreCalculation() async {
        let game = Game(rows: 3, columns: 3, playerType: .human, numberOfPlayers: 2)
        
        // Assign 4 dice to green
        let greenDice = [game.rows[0][0], game.rows[0][1], game.rows[1][0], game.rows[1][1]]
        greenDice.forEach { $0.owner = .green }
        
        #expect(game.score(for: .green) == 4)
    }
    @Test
    func hasValidMoves() async {
        let game = Game(rows: 2, columns: 2, playerType: .human, numberOfPlayers: 2)
        
        // Initial state should have valid moves
        #expect(game.isGameOver == false)
        
        // Block all valid moves
        game.rows.forEach { row in
            row.forEach { die in
                die.value = die.neighbors + 1
                die.owner = .red
            }
        }
        
        #expect(game.isGameOver == true)
    }
    
    /// Test winner calculation in a tied game.
    @Test
    func winnerTie() async {
        let game = Game(rows: 2, columns: 2, playerType: .human, numberOfPlayers: 2)
        
        // Split ownership between players
        game.rows[0][0].owner = .green
        game.rows[0][1].owner = .green
        game.rows[1][0].owner = .red
        game.rows[1][1].owner = .red
        
        #expect(game.winner == nil)
    }
}
