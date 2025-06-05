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
        self.numRows = rows
        self.numCols = columns
        self.playerType = playerType
        self.numberOfPlayers = numberOfPlayers
        
        let initializedPlayers = Array(Player.allPlayers.prefix(numberOfPlayers))
        self.activePlayer = initializedPlayers.first ?? .green
        self.players = initializedPlayers
        
        self.rows = [[Dice]]()
        self.rows = (0..<numRows).map { row in
            (0..<numCols).map { col in
                Dice(row: row, column: col, neighbors: countNeighbors(row: row, col: col))
            }
        }
    }
    
    private func countNeighbors(row: Int, col: Int) -> Int {
        var result = 0
        if col > 0 { result += 1 }
        if col < numCols - 1 { result += 1 }
        if row > 0 { result += 1 }
        if row < numRows - 1 { result += 1 }
        return result
    }
    
    func reset(rows: Int, columns: Int, playerType: PlayerType, numberOfPlayers: Int) {
        self.numRows = rows
        self.numCols = columns
        
        self.rows = (0..<rows).map { row in
            (0..<columns).map { col in
                Dice(row: row, column: col, neighbors: countNeighbors(row: row, col: col))
            }
        }
        
        self.changeList.removeAll()
        self.aiClosedList.removeAll()
        self.changeAmount = 0.0
        self.state = .waiting
        
        self.playerType = playerType
        self.numberOfPlayers = numberOfPlayers
        self.players = Array(Player.allPlayers.prefix(numberOfPlayers))
        self.activePlayer = self.players.first ?? .green
        
        // Start AI turn if needed
        if playerType == .ai && activePlayer == .red {
            Task {
                try? await Task.sleep(for: .seconds(0.5))
                executeAITurn()
            }
        }
    }
    
    var isGameOver: Bool {
        let allOwnedByOnePlayer = players.contains { player in
            rows.allSatisfy { row in
                row.allSatisfy { $0.owner == player }
            }
        }
        
        let noValidMovesForAnyPlayer = players.allSatisfy { player in
            !hasValidMoves(for: player)
        }
        
        return allOwnedByOnePlayer || noValidMovesForAnyPlayer
    }
    
    private func hasValidMoves(for player: Player) -> Bool {
        for row in rows {
            for dice in row {
                if (dice.owner == .none || dice.owner == player) && dice.value <= dice.neighbors {
                    return true
                }
            }
        }
        return false
    }
    
    var winner: Player? {
        guard isGameOver else { return nil }
        let scores = players.map { ($0, score(for: $0)) }
        let maxScore = scores.map(\.1).max() ?? 0
        let topPlayers = scores.filter { $0.1 == maxScore }
        if topPlayers.count == 1 {
            return topPlayers.first?.0
        }
        return nil
    }
    
    private func checkMove(for dice: Dice) {
        if aiClosedList.contains(where: { $0.id == dice.id }) { return }
        aiClosedList.append(dice)
        
        if dice.value + 1 > dice.neighbors {
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
                // Skip if we can't move this piece
                if dice.owner != .none && dice.owner != aiPlayer {
                    continue
                }
                
                // Skip if the dice would explode
                if dice.value > dice.neighbors {
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
                            score += 10
                        }
                    }
                }
                
                if score > bestScore {
                    bestScore = score
                    bestDice.removeAll()
                    bestDice.append(dice)
                } else if score == bestScore {
                    bestDice.append(dice)
                }
            }
        }
        
        if bestDice.isEmpty {
            return nil
        }
        
        if Bool.random() {
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
            return bestDice.randomElement()
        }
    }
    
    private func executeAITurn() {
        guard state == .thinking else { return }
        
        if let dice = getBestMove() {
            changeList.append((dice.row, dice.column))
            state = .changing
            runChanges()
        } else {
            nextTurn()
        }
    }
    
    private func getNeighbors(row: Int, col: Int) -> [Dice] {
        var result = [Dice]()
        if col > 0 { result.append(rows[row][col - 1]) }
        if col < numCols - 1 { result.append(rows[row][col + 1]) }
        if row > 0 { result.append(rows[row - 1][col]) }
        if row < numRows - 1 { result.append(rows[row + 1][col]) }
        return result
    }
    
    private func getNeighborIndices(row: Int, col: Int) -> [(Int, Int)] {
        var result: [(Int, Int)] = []
        if col > 0 { result.append((row, col - 1)) }
        if col < numCols - 1 { result.append((row, col + 1)) }
        if row > 0 { result.append((row - 1, col)) }
        if row < numRows - 1 { result.append((row + 1, col)) }
        return result
    }
    
    private func bump(row: Int, col: Int) {
        guard rows.indices.contains(row), rows[row].indices.contains(col) else { return }
        
        rows[row][col].value += 1
        rows[row][col].owner = activePlayer
        rows[row][col].changeAmount = 1
        
        
        // Animate the change amount back to 0
            withAnimation(.easeOut(duration: 0.3)) {
                self.rows[row][col].changeAmount = 0
            }
        
        if rows[row][col].value > rows[row][col].neighbors {
            rows[row][col].value = 1
            
            for (nRow, nCol) in getNeighborIndices(row: row, col: col) {
                changeList.append((nRow, nCol))
            }
        }
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
        Task {
            try? await Task.sleep(for: .seconds(0.25))
            runChanges()
        }
    }
    
    private func nextTurn() {
        guard let currentIndex = players.firstIndex(of: activePlayer) else { return }
        var nextIndex = (currentIndex + 1) % players.count
        var attempts = 0
        
        // Find next player with valid moves
        while !hasValidMoves(for: players[nextIndex]) && attempts < players.count {
            nextIndex = (nextIndex + 1) % players.count
            attempts += 1
        }
        
        // If no player has valid moves, game is over
        if attempts >= players.count {
            state = .waiting
            return
        }
        
        activePlayer = players[nextIndex]
        
        if activePlayer == .red && playerType == .ai {
            state = .thinking
            Task {
                try? await Task.sleep(for: .seconds(0.5))
                    executeAITurn()
            }
        } else {
            state = .waiting
        }
    }
    
    func increment(_ dice: Dice) {
        guard state == .waiting else { return }
        guard dice.owner == .none || dice.owner == activePlayer else { return }
        guard dice.value <= dice.neighbors else { return }
        
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
