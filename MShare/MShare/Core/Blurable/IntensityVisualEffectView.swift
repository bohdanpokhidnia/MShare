//
//  IntensityVisualEffectView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 17.04.2024.
//

import UIKit

final class IntensityVisualEffectView: UIVisualEffectView {
    // MARK: - Initializers
    
    init(effect: UIVisualEffect, intensity: CGFloat) {
        originalEffect = effect
        customIntensity = intensity
        super.init(effect: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    deinit {
        animator?.stopAnimation(true)
    }
    
    // MARK: - Override methods
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
            self.effect = originalEffect
        }
        animator?.fractionComplete = customIntensity
    }
    
    // MARK: - Private
    
    private let originalEffect: UIVisualEffect
    private let customIntensity: CGFloat
    private var animator: UIViewPropertyAnimator?
}
