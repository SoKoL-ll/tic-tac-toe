//
//  AIPlayer.swift
//  tic-tac-toe
//
//  Created by Alexandr Sokolov on 09.04.2024.
//

import Foundation

final class AIPlayer {
    private func evaluate(board: [String]) -> Int {
        let winningPositions: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]

        for positions in winningPositions {
            if board[positions[0]] == board[positions[1]] && board[positions[0]] == board[positions[2]] {
                if board[positions[0]] == "X" {
                    return 10
                } else if board[positions[0]] == "O" {
                    return -10
                }
            }
        }
        return 0
    }

    private func isMovesLeft(board: [String]) -> Bool {
        return board.contains("")
    }

    private func minimax(board: [String], depth: Int, isMaximizing: Bool) -> Int {
        let score = evaluate(board: board)
        
        if score == 10 {
            return score - depth
        }

        if score == -10 {
            return score + depth
        }

        if !isMovesLeft(board: board) {
            return 0
        }

        if isMaximizing {
            var bestScore = Int.min

            for i in 0..<9 {
                if board[i] == "" {
                    var newBoard = board
                    newBoard[i] = "X"
                    bestScore = max(bestScore, minimax(board: newBoard, depth: depth + 1, isMaximizing: false))
                }
            }

            return bestScore
        } else {
            var bestScore = Int.max

            for i in 0..<9 {
                if board[i] == "" {
                    var newBoard = board
                    newBoard[i] = "O"
                    bestScore = min(bestScore, minimax(board: newBoard, depth: depth + 1, isMaximizing: true))
                }
            }

            return bestScore
        }
    }

    func findBestMove(board: [String]) -> Int {
        var bestMove = -1
        var bestVal = Int.min

        for i in 0..<9 {
            if board[i] == "" {
                var newBoard = board
                newBoard[i] = "X"
                let moveVal = minimax(board: newBoard, depth: 0, isMaximizing: false)
                if moveVal > bestVal {
                    bestMove = i
                    bestVal = moveVal
                }
            }
        }

        return bestMove
    }
}
