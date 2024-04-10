//
//  ViewController.swift
//  tic-tac-toe
//
//  Created by Alexandr Sokolov on 04.04.2024.
//

import UIKit
import SnapKit

protocol MainScreenViewControllerProtocol: AnyObject {
    func finishTheGame(result: String)
    func setTurn(tag: Int, turn: Turn)
    func resetBoard()
}

final class MainScreenViewController: UIViewController {

    private var currentTurn = Turn.Cross {
        didSet {
            turnLabel.text = "Ход: \(currentTurn.rawValue)"
        }
    }

    private var board = [Int: UIButton]()

    private var gameMode: GameMode = .computer {
        didSet {
            let attributedString = NSMutableAttributedString()

            attributedString.append(NSAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: gameMode.rawValue) ?? UIImage())))
            gameModeLabel.attributedText = attributedString
        }
    }

    var presenter: MainScreenPresenterProtocol?

    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView()

        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 5
        view.backgroundColor = .black

        return view
    }()

    private lazy var turnLabel: UILabel = {
        let label = UILabel()

        label.text = "Ход: \(currentTurn.rawValue)"
        label.font = .boldSystemFont(ofSize: Constants.textSize)
        label.textColor = .black

        return label
    }()

    private lazy var gameModeLabel: UILabel = {
        let label = UILabel()

        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: gameMode.rawValue) ?? UIImage())))
        label.attributedText = attributedString

        label.font = .boldSystemFont(ofSize: Constants.textSize)
        label.textColor = .black

        return label
    }()

    private lazy var settingsImageView: UIImageView = {
        let settingsImage = UIImage(systemName: "gearshape.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let settingsImageView = UIImageView(image: settingsImage)

        return settingsImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupVerticalStack()
        setupTurnLabel()
        setupGameModeLabel()
        setupSettingsButton()
    }

    private func setupVerticalStack() {
        for i in 0..<3 {
            let horisontalStackView: UIStackView = {
                let view = UIStackView()

                view.axis = .horizontal

                view.distribution = .fillEqually
                view.spacing = 5
                view.backgroundColor = .black
                return view
            }()

            for j in 0..<3 {
                let button: UIButton = {
                    let button = UIButton(type: .system)

                    button.titleLabel?.font = .systemFont(ofSize: Constants.textBigSize, weight: .bold)
                    button.setTitleColor(.black, for: .normal)
                    button.backgroundColor = .white
                    button.tag = (i * 3) + j
                    button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

                    return button
                }()

                board[(i * 3) + j] = button
                horisontalStackView.addArrangedSubview(button)
            }

            verticalStackView.addArrangedSubview(horisontalStackView)
        }

        view.addSubview(verticalStackView)

        verticalStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.margin)
            make.height.equalTo(verticalStackView.snp.width)
        }
    }

    private func setupTurnLabel() {
        view.addSubview(turnLabel)

        turnLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(Constants.bigMargin)
        }
    }

    private func setupGameModeLabel() {
        view.addSubview(gameModeLabel)

        gameModeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.margin)
            make.top.equalToSuperview().inset(Constants.bigMargin)
        }
    }


    private func setupSettingsButton() {

        let button = UIButton()

        button.addSubview(settingsImageView)

        let action1 = UIAction(title: Texts.repeat, image: UIImage(systemName: "repeat")) { [weak self] action in
            guard let self = self else { return }

            self.presenter?.newGame()
        }

        let action2 = UIAction(title: Texts.changeMode) { [weak self] action in
            guard let self = self else { return }

            switch self.gameMode {
            case .computer:
                self.gameMode = .duo
            case .duo:
                self.gameMode = .computer
            }
            
            self.presenter?.changeGameMode(mode: self.gameMode)
        }

        let menu = UIMenu(title: "", children: [action1, action2])

        button.menu = menu
        button.showsMenuAsPrimaryAction = true

        settingsImageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }

        button.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchDown)

        view.addSubview(button)

        button.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constants.margin)
            make.top.equalTo(turnLabel.snp.top)
            make.width.height.equalTo(Constants.buttonHeight)
        }
    }

    @objc func buttonTapped(_ sender: UIButton) {
        presenter?.setTurn(cell: sender.tag)
    }

    @objc func settingsButtonTapped(_ sender: UIButton) {
        self.settingsImageView.addSymbolEffect(.bounce.up.byLayer)
    }
}

extension MainScreenViewController: MainScreenViewControllerProtocol {
    func finishTheGame(result: String) {
        let ac = UIAlertController(title: result, message: nil, preferredStyle: .actionSheet)

        ac.addAction(UIAlertAction(title: Texts.repeat, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.newGame()
        })

        self.present(ac, animated: true)
    }

    func setTurn(tag: Int, turn: Turn) {
        currentTurn = turn == .Cross ? .Nought : .Cross
        board[tag]?.setTitle(turn.rawValue, for: .normal)
    }

    func resetBoard() {
        board.values.forEach {
            $0.setTitle(nil, for: .normal)
        }

        currentTurn = .Cross
        self.turnLabel.setNeedsLayout()
        view.layoutSubviews()
    }
}

private extension MainScreenViewController {
    struct Constants {
        static let margin: CGFloat = 20
        static let bigMargin: CGFloat = 64
        static let textSize: CGFloat = 24
        static let textBigSize: CGFloat = 64
        static let buttonHeight: CGFloat = 30
    }

    struct Texts {
        static let `repeat`: String = "Заново"
        static let changeMode: String = "Изменить режим"
    }
}
