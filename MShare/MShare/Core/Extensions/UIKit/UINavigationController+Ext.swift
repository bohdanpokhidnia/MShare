//
//  UINavigationController+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 17.04.2023.
//

import UIKit

extension UINavigationController {
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
    
    func popViewController(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
    
    func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        pushViewController(viewController, animated: animated)
        completionHelper(for: completion)
    }
}

// MARK: - Private Methods

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
