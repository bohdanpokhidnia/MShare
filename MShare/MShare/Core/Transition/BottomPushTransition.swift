//
//  BottomPushTransition.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 16.04.2023.
//

import UIKit

class BottomPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        
        let bounds = containerView.bounds
        toView.frame = bounds.offsetBy(dx: 0, dy: bounds.height)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            toView.frame = bounds
        } completion: { position in
            let finished = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(finished)
        }
    }
    
    // MARK: - Private
    
    private let duration: TimeInterval = 0.5
}
