//
//  Blurable.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 13.08.2022.
//

import UIKit

protocol Blurable {
    func addBlur() -> Self
}

extension Blurable where Self: UIImageView {
    
    @discardableResult
    func addBlur() -> Self {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = bounds
        blurEffectView.backgroundColor = .clear
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(blurEffectView)
        return self
    }
    
}

extension UIImageView: Blurable {}

