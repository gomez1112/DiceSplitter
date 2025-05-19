//
//  Game.swift
//  DiceSplitter
//
//  Created by Gerard Gomez on 1/26/25.
//

import Foundation
import Observation
import SwiftUI


@Observable
@MainActor
final class Game {
    var rows: [[Dice]]
    var changeList = [(row: Int, col: Int)]()
    var changeAmount = 0.0
    
    private var aiClosedList = [Dice]()
    private var numRows: Int
    private var numCols: Int
    private var playerType: PlayerType
    private var numberOfPlayers: Int
    
    var activePlayer: Player
    var players: [Player]
    var state = GameState.waiting
    
    init(rows: Int, columns: Int, playerType: PlayerType, numberOfPlayers: Int) {
        // Initialize stored properties first
        self.numRows = rows
        self.numCols = columns
        self.playerType = playerType
        self.numberOfPlayers = numberOfPlayers
        
        // Initialize players based on the number of players selected
        let initializedPlayers = Array(Player.allPlayers.prefix(numberOfPlayers))
        
        // Use the local variable to initialize activePlayer
        self.activePlayer = initializedPlayers.first ?? .green
        
        // Now assign the players property
        self.players = initializedPlayers
        
        // Initialize rows
        self.rows = [[Dice]]()
        // Create the initial board using the current numRows and numCols.
        self.rows = (0..<numRows).map { row in
            (0..<numCols).map { col in
                Dice(row: row, column: col, neighbors: countNeighbors(row: row, col: col))
            }
        }
    }
    
    func reset(rows: Int, columns: Int, playerType: PlayerType, numberOfPlayers: Int) {
        // Update board dimensions
        self.numRows = rows
        self.numCols = columns
        
        // Reinitialize the board with new Dice (all with value = 1 and owner = .none)
        self.rows = (0..<rows).map { row in
            (0..<columns).map { col in
                Dice(row: row, column: col, neighbors: countNeighbors(row: row, col: col))
            }
        }
        
        // Clear any leftover state
        self.changeList.removeAll()
        self.aiClosedList.removeAll()
        self.changeAmount = 0.0
        self.state = .waiting
        
        // Update players and the active player
        self.playerType = playerType
        self.numberOfPlayers = numberOfPlayers
        self.players = Array(Player.allPlayers.prefix(numberOfPlayers))
        self.activePlayer = self.players.first ?? .green
    }

    var isGameOver: Bool {
        // Condition 1: All dice are owned by one player
        let allOwnedByOnePlayer = players.contains { player in
            rows.allSatisfy { row in
                row.allSatisfy { $0.owner == player }
            }
        }
        
        // Condition 2: No valid moves left for any player
        let noValidMovesForAnyPlayer = players.allSatisfy { player in
            !hasValidMoves(for: player)
        }

        
        // Condition 3: AI cannot make any more moves (if AI is playing)
        let aiCannotMove = playerType == .ai && activePlayer == .red && !hasValidMoves(for: .red)
        
        return allOwnedByOnePlayer || noValidMovesForAnyPlayer || aiCannotMove
    }
    
    private func hasValidMoves(for player: Player) -> Bool {
        for row in rows {
            for dice in row {
                // A move is valid if:
                // 1. The dice is unowned or owned by the player.
                // 2. The dice's value is less than or equal to its number of neighbors.
                if (dice.owner == .none || dice.owner == player) && dice.value <= dice.neighbors {
                    return true
                }
            }
        }
        return false
    }
    
    // Add a computed property to determine the winner
    var winner: Player? {
        guard isGameOver else { return nil }
        let scores = players.map { ($0, score(for: $0)) }
        let maxScore = scores.map(\.1).max() ?? 0
        let topPlayers = scores.filter { $0.1 == maxScore }
        if topPlayers.count == 1 {
            return topPlayers.first?.0
        }
        return nil // Tie
    }

    private func checkMove(for dice: Dice) {
        if aiClosedList.contains(dice) { return }
        aiClosedList.append(dice)
        
        if dice.value + 1 > dice.neighbors {
            // this die would break if we bumped it!
            for neighbor in getNeighbors(row: dice.row, col: dice.column) {
                checkMove(for: neighbor)
            }
        }
    }
    
    private func getBestMove() -> Dice? {
        let aiPlayer = Player.red
        var bestDice = [Dice]()
        var bestScore = -9999
        
        for row in rows {
            for dice in row {
                if dice.owner != .none && dice.owner != aiPlayer {
                    // we can't move their pieces
                    continue
                }
                
                aiClosedList.removeAll()
                checkMove(for: dice)
                
                var score = 0
                
                for checkDice in aiClosedList {
                    if checkDice.owner == .none || checkDice.owner == aiPlayer {
                        score += 1
                    } else {
                        score += 10
                    }
                }
                
                let compareList = getNeighbors(row: dice.row, col: dice.column)
                
                for checkDice in compareList {
                    if checkDice.owner == aiPlayer { continue }
                    
                    if checkDice.value > dice.value {
                        score -= 50
                    } else {
                        if checkDice.owner != .none {
                            // if we bump this dice, it's next to an opponent's piece of lower value, so we can capture it
                            score += 10
                        }
                    }
                }
                
                if score > bestScore {
                    // this is a better score than what we had before - clear all the options and use this one
                    bestScore = score
                    bestDice.removeAll()
                    bestDice.append(dice)
                } else if score == bestScore {
                    // this move is as good as our previous move
                    bestDice.append(dice)
                }
            }
        }
        
        if bestDice.isEmpty {
            return nil
        }
        
        if Bool.random() {
            // 50% of the time we fortify
            var highestValue = 0
            var selection = [Dice]()
            
            for dice in bestDice {
                if dice.value > highestValue {
                    highestValue = dice.value
                    selection.removeAll()
                    selection.append(dice)
                } else if dice.value == highestValue {
                    selection.append(dice)
                }
            }
            
            return selection.randomElement()
        } else {
            // 50% of the time we play randomly
            return bestDice.randomElement()
        }
        
    }
    
    private func executeAITurn() {
        if let dice = getBestMove() {
            changeList.append((dice.row, dice.column))
            state = .changing
            runChanges()
        } else {
            print("No moves!")
            nextTurn()
        }
    }
    
    private func countNeighbors(row: Int, col: Int) -> Int {
        var result = 0
        
        if col > 0 { // one to the left
            result += 1
        }
        
        if col < numCols - 1 { // one to the right
            result += 1
        }
        
        if row > 0 { // one above
            result += 1
        }
        
        if row < numRows - 1 {  // one below
            result += 1
        }
        
        return result
    }
    
    private func getNeighbors(row: Int, col: Int) -> [Dice] {
        var result = [Dice]()
        
        if col > 0 { // one to the left
            result.append(rows[row][col - 1])
        }
        
        if col < numCols - 1 { // one to the right
            result.append(rows[row][col + 1])
        }
        
        if row > 0 { // one above
            result.append(rows[row - 1][col])
        }
        
        if row < numRows - 1 {  // one below
            result.append(rows[row + 1][col])
        }
        
        return result
    }
    
    private func bump(row: Int, col: Int) {
        // Make sure indices are valid
        guard rows.indices.contains(row), rows[row].indices.contains(col) else { return }
        
        // Mutate dice in place
        rows[row][col].value += 1
        rows[row][col].owner = activePlayer
        rows[row][col].changeAmount = 1
        
        // You can't use withAnimation in a model method; do it in the view instead,
        // or use a callback. (Omit for pure model logic.)
        // withAnimation { rows[row][col].changeAmount = 0 }
        
        // Check for explosion
        if rows[row][col].value > rows[row][col].neighbors {
            rows[row][col].value = 1
            
            // For each neighbor, add its (row, col) to changeList
            for (nRow, nCol) in getNeighborIndices(row: row, col: col) {
                changeList.append((nRow, nCol))
            }
        }
    }
    private func getNeighborIndices(row: Int, col: Int) -> [(Int, Int)] {
        var result: [(Int, Int)] = []
        if col > 0 { result.append((row, col - 1)) }
        if col < numCols - 1 { result.append((row, col + 1)) }
        if row > 0 { result.append((row - 1, col)) }
        if row < numRows - 1 { result.append((row + 1, col)) }
        return result
    }
    
    private func runChanges() {
        if changeList.isEmpty {
            nextTurn()
            return
        }
        let toChange = changeList
        changeList.removeAll()
        
        for (row, col) in toChange {
            bump(row: row, col: col)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.runChanges()
        }
    }
    
    private func nextTurn() {
        guard let currentIndex = players.firstIndex(of: activePlayer) else { return }
        var nextIndex = (currentIndex + 1) % players.count
        let originalIndex = currentIndex
        var searched = 0
        
        while nextIndex != originalIndex && !hasValidMoves(for: players[nextIndex]) {
            nextIndex = (nextIndex + 1) % players.count
            searched += 1
            if searched > players.count { break }
        }
        if activePlayer == .red && playerType == .ai {
            state = .thinking
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.executeAITurn()
            }
        } else {
            state = .waiting
        }
    }
    func
    increment(_ dice: Dice) {
        guard state == .waiting else { return }
        guard dice.owner == .none || dice.owner == activePlayer else { return }
        
        state = .changing
        changeList.append((dice.row, dice.column))
        runChanges()
    }
    
    func score(for player: Player) -> Int {
        var count = 0
        
        for row in rows {
            for col in row {
                if col.owner == player {
                    count += 1
                }
            }
        }
        
        return count
    }
}
