//
//  UIApplication.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 11.01.2023.
//

import UIKit

extension UIApplication {
    
    static var windowScene: UIWindowScene { shared.connectedScenes.first as! UIWindowScene }
    static var sceneDelegate: SceneDelegate { windowScene.delegate as! SceneDelegate }
    
    static var safeAreaInsets: UIEdgeInsets {
        return windowScene.windows.first!.safeAreaInsets
    }
    
    static func load(vc: UIViewController) {
        let window = UIWindow(windowScene: Self.windowScene)
        sceneDelegate.window = window
        
        window.rootViewController = vc
        window.backgroundColor(color: .systemBackground)
        window.makeKeyAndVisible()
    }
    
}
