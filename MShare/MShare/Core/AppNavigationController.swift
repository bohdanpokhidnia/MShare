//
//  AppNavigationController.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.04.2023.
//

import UIKit

class AppNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    var isRecognizerEnabled = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1 && isRecognizerEnabled
    }

}
