//
//  File.swift
//  tic-tac-toe
//
//  Created by Alexandr Sokolov on 05.04.2024.
//

import Foundation

enum Turn: String {
    case Nought = "O"
    case Cross = "X"
}

enum GameMode: String {
    case computer = "pc"
    case duo = "person.2.fill"
}

struct GameState {
    var currentTurn: Turn
    var board: [String]
    var freeCells: Int
    var gameMode: GameMode

    init(
        currentTurn: Turn = .Cross,
        board: [String] = [],
        freeCells: Int = 0,
        gameMode: GameMode = .computer
    ) {
        self.currentTurn = currentTurn
        self.board = board
        self.freeCells = freeCells
        self.gameMode = gameMode
    }
}
