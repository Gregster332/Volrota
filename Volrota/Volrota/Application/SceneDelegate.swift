//
//  SceneDelegate.swift
//  Volrota
//
//  Created by Григорий on 30.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var rootCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let dependencies = dependencies()
        rootCoordinator = AppCoordinator(dependencies: dependencies)

        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        self.window = window
        rootCoordinator?.setRoot(for: window)
    }
}


