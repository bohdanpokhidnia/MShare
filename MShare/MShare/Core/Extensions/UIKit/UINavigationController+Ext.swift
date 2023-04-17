//
//  UINavigationController+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 17.04.2023.
//

import UIKit

extension UINavigationController {
    
    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
    
}
