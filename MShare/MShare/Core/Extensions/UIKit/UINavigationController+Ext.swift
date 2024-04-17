//
//  UINavigationController+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 17.04.2023.
//

import UIKit

extension UINavigationController {
    func popViewController(animated: Bool, completion: (() -> Void)?) {
        popViewController(animated: animated)
        completionHelper(for: completion)
    }
    
    func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        pushViewController(viewController, animated: animated)
        completionHelper(for: completion)
    }
    
    enum NavigationBarStyle {
        case `default`
        case opaque
        case transparent
    }
    
    func configure(style: NavigationBarStyle) {
        let navigationBarAppearance = UINavigationBarAppearance()
        
        switch style {
        case .default:
            navigationBarAppearance.configureWithDefaultBackground()
            
        case .opaque:
            navigationBarAppearance.configureWithOpaqueBackground()
            
        case .transparent:
            navigationBarAppearance.configureWithTransparentBackground()
        }
        
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.shadowColor = nil
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}

private extension UINavigationController {
    func completionHelper(for completion: (() -> Void)?) {
        if let transitionCoordinator = self.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }
}
