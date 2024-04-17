//
//  Blurable.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 13.08.2022.
//

import UIKit

protocol Blurable {
    func addBlur(style: UIBlurEffect.Style, intensity: CGFloat) -> Self
    func addClipBlur(style: UIBlurEffect.Style, intensity: CGFloat, cornerRadius: CGFloat) -> Self
}

extension UIView: Blurable { }

extension Blurable where Self: UIView {
    @discardableResult
    func addBlur(style: UIBlurEffect.Style, intensity: CGFloat) -> Self {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = IntensityVisualEffectView(effect: blurEffect, intensity: intensity)
        
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(blurEffectView)
        return self
    }
    
    @discardableResult
    func addClipBlur(style: UIBlurEffect.Style, intensity: CGFloat, cornerRadius: CGFloat) -> Self {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = IntensityVisualEffectView(effect: blurEffect, intensity: intensity)
        
        blurEffectView.frame = bounds
        blurEffectView.layer.cornerRadius = cornerRadius
        blurEffectView.clipsToBounds = true
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(blurEffectView)
        return self
    }
}
