//
//  UIViewController+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 19.11.2022.
//

import UIKit

extension UIViewController {
    
    // Get ViewController in top present level
    var topPresentedViewController: UIViewController? {
        var target: UIViewController? = self
        while (target?.presentedViewController != nil) {
            target = target?.presentedViewController
        }
        return target
    }
    
    // Get top VisibleViewController from ViewController stack in same present level.
    // It should be visibleViewController if self is a UINavigationController instance
    // It should be selectedViewController if self is a UITabBarController instance
    var topVisibleViewController: UIViewController? {
        if let navigation = self as? UINavigationController {
            if let visibleViewController = navigation.visibleViewController {
                return visibleViewController.topVisibleViewController
            }
        }
        if let tab = self as? UITabBarController {
            if let selectedViewController = tab.selectedViewController {
                return selectedViewController.topVisibleViewController
            }
        }
        return self
    }
    
    // Combine both topPresentedViewController and topVisibleViewController methods, to get top visible viewcontroller in top present level
    var topMostViewController: UIViewController? {
        return self.topPresentedViewController?.topVisibleViewController
    }
    
    func add(child: UIViewController, to childContainerView: UIView) {
        addChild(child)
        childContainerView.addSubview(child.view)
        addFullScreenConstraints(view: childContainerView, childView: child.view)
        child.didMove(toParent: self)
    }
    
    private func addFullScreenConstraints(view: UIView, childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            view.leadingAnchor.constraint(equalTo: childView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: childView.trailingAnchor),
            view.topAnchor.constraint(equalTo: childView.topAnchor),
            view.bottomAnchor.constraint(equalTo: childView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        view.addConstraints(constraints)
    }
    
}
