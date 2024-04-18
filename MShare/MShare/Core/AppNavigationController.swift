//
//  AppNavigationController.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.04.2023.
//

import UIKit

final class AppNavigationController: UINavigationController {
    var isRecognizerEnabled = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(style: .transparent)
        
        navigationBar.tintColor = .appPink
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
}

// MARK: - UIGestureRecognizerDelegate

extension AppNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isBegin = viewControllers.count > 1 && isRecognizerEnabled
        return isBegin
    }
}
