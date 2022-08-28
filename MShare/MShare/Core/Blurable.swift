//
//  Blurable.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 13.08.2022.
//

import UIKit

protocol Blurable {
    func addBlur(style: UIBlurEffect.Style) -> Self
    func addClearBackgroundBlur(style: UIBlurEffect.Style) -> Self
}

extension Blurable where Self: UIView {
    
    @discardableResult
    func addBlur(style: UIBlurEffect.Style) -> Self {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(blurEffectView)
        return self
    }
    
    @discardableResult
    func addClearBackgroundBlur(style: UIBlurEffect.Style) -> Self {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = bounds
        blurEffectView.backgroundColor = .clear
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(blurEffectView)
        return self
    }
    
}

extension UIView: Blurable {}

