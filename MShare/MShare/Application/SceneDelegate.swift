//
//  SceneDelegate.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainView: MainViewProtocol?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        configureNavigationBarStyle()
        configureTabBarStyle()
        
        mainView = MainRouter.createModule()
        mainView?.selectedTab(2)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = mainView?.viewController
        window?.makeKeyAndVisible()
    }
    
    func configureNavigationBarStyle() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
    func configureTabBarStyle() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
}

