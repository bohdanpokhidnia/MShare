//
//  ToBottomPopTransition.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 16.04.2023.
//

import UIKit

class ToBottomPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
        containerView.insertSubview(toView, at: 0)
        
        let bounds = containerView.bounds
        toView.frame = bounds
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            fromView.frame = bounds.offsetBy(dx: 0, dy: bounds.height)
        } completion: { position in
            let finished = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(finished)
        }
    }
    
    // MARK: - Private
    
    private let duration: TimeInterval = 0.5
    
}
