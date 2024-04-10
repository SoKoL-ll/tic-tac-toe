//
//  SceneDelegate.swift
//  tic-tac-toe
//
//  Created by Alexandr Sokolov on 04.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: scene)
        let mainScreenViewController = MainScreenViewController()

        let mainScreenPresenter = MainScreenPresenter(view: mainScreenViewController)
        mainScreenViewController.presenter = mainScreenPresenter
        
        window?.rootViewController = mainScreenViewController
        window?.makeKeyAndVisible()
    }
}

