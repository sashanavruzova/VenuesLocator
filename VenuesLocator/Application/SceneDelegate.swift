//
//  SceneDelegate.swift
//  VenuesLocator
//
//  Created by Sasha Navruzova on 01.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        mainCoordinator = MainCoordinator(navigationController: navigationController)
        
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
        
        mainCoordinator?.start()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        mainCoordinator?.appDidEnterForeground()

    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        mainCoordinator?.appDidEnterBackground()
    }


}

