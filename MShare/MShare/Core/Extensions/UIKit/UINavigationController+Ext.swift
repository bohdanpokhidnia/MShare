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
