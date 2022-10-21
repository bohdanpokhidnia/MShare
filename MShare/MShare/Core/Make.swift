//
//  Make.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

protocol Make {}

extension Make {
    
    @discardableResult
    func make(_ completion: (Self) -> Void) -> Self {
        completion(self)
        return self
    }
    
}

// MARK: - MakeProtocol

extension UIView: Make { }

extension UIViewController: Make { }

extension CAGradientLayer: Make { }
