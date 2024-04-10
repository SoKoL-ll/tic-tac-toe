//
//  MainScreenPresenter.swift
//  tic-tac-toe
//
//  Created by Alexandr Sokolov on 04.04.2024.
//

import Foundation

protocol MainScreenPresenterProtocol: AnyObject {
    func setTurn(cell: Int)
    func newGame()
    func changeGameMode(mode: GameMode)
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    weak var view: MainScreenViewControllerProtocol?
    
    var state = GameState()
    let aiPlayer = AIPlayer()

    init(view: MainScreenViewControllerProtocol) {
        self.view = view

        newGame()
    }

    private func resetBoard() {
        state = GameState(
            currentTurn: .Cross,
            board: Array(
                repeating: "",
                count: 9
            ),
            freeCells: 9,
            gameMode: self.state.gameMode
        )
    }

    @discardableResult
    private func checkForWin() -> Bool {
        let winPatterns: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]

        for pattern in winPatterns {
            if pattern.map({ state.board[$0] }) == Array(repeating: state.currentTurn == .Cross ? "O" : "X" , count: 3) {
                view?.finishTheGame(result: "\(Texts.win) \(state.currentTurn == .Cross ? "O" : "X")")
                return true
            }
        }

        if state.freeCells == 0 {
            view?.finishTheGame(result: Texts.draw)

            return true
        }

        return false
    }

    func setTurn(cell: Int) {
        if state.board[cell] == "" {
            state.freeCells -= 1
            switch state.gameMode {
            case .computer:
                state.board[cell] = state.currentTurn.rawValue
                view?.setTurn(tag: cell, turn: state.currentTurn)

                if !checkForWin() {
                    state.currentTurn = .Nought
                    let aiMove = aiPlayer.findBestMove(board: self.state.board)
                    state.board[aiMove] = state.currentTurn.rawValue
                    view?.setTurn(tag: aiMove, turn: state.currentTurn)
                    state.currentTurn = .Cross
                    state.freeCells -= 1
                }
            case .duo:
                switch state.currentTurn {
                case .Cross:
                    state.board[cell] = state.currentTurn.rawValue
                    view?.setTurn(tag: cell, turn: state.currentTurn)
                    state.currentTurn = .Nought
                case .Nought:
                    state.board[cell] = state.currentTurn.rawValue
                    view?.setTurn(tag: cell, turn: state.currentTurn)
                    state.currentTurn = .Cross
                }
            }
            
            checkForWin()
        }
    }

    func newGame() {
        resetBoard()
        view?.resetBoard()
    }

    func changeGameMode(mode: GameMode) {
        newGame()
        self.state.gameMode = mode
    }
}

private extension MainScreenPresenter {
    struct Texts {
        static let win = "Победа"
        static let draw = "Ничья"
    }
}
