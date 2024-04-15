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
    
    static var isSmallScreenRatio: Bool {
        let width = windowScene.screen.bounds.width
        let height = windowScene.screen.bounds.height
        let isSmall = (height / width) < 2
        return isSmall
    }
}
