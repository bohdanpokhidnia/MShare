//
//  MoveElementsTransition.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 16.04.2023.
//

import UIKit

class MoveElementsTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var operation: UINavigationController.Operation = .push
    
    init(operation: UINavigationController.Operation) {
        self.operation = operation
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! TransitionProtocol
        let fromContentView = fromViewController.transitionView
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! TransitionProtocol
        let toContentView = toViewController.transitionView
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(fromViewController.transitionView)
        containerView.addSubview(toViewController.transitionView)
        
        if operation == .pop {
            containerView.bringSubviewToFront(fromContentView)
        }
        
        toContentView.setNeedsLayout()
        toContentView.layoutIfNeeded()
        
        let fromViews = fromViewController.viewsToAnimate()
        let toViews = toViewController.viewsToAnimate()
        
        assert(fromViews.count == toViews.count, "Number of elements in fromViews and toViews have to be the same.")
        
        var intermediateViews = [UIView]()
        
        var toFrames = [CGRect]()
        
        for i in 0..<fromViews.count {
            let fromView = fromViews[i]
            let fromFrame = fromView.superview!.convert(fromView.frame, to: nil)
            fromView.alpha = 0
            
            let intermediateView = fromViewController.copyForView(fromView)
            intermediateView.frame = fromFrame
            containerView.addSubview(intermediateView)
            intermediateViews.append(intermediateView)
            
            let toView = toViews[i]
            var toFrame: CGRect
            if let tempToFrame = toViewController.frameForView?(toView) {
                toFrame = tempToFrame
            } else {
                toFrame = toView.superview!.convert(toView.frame, to: nil)
            }
            toFrames.append(toFrame)
            toView.alpha = 0
        }
        
        if operation == .push {
            toContentView.frame = fromContentView.frame.offsetBy(dx: fromContentView.frame.size.width, dy: 0)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: [], animations: { () -> Void in
            if self.operation == .pop {
                fromContentView.frame = fromContentView.frame.offsetBy(dx: fromContentView.frame.size.width, dy: 0)
            } else {
                toContentView.frame = fromContentView.frame
            }
            
            for i in 0..<intermediateViews.count {
                let intermediateView = intermediateViews[i]
                intermediateView.frame = toFrames[i]
            }
        }) { (_) -> Void in
            for i in 0..<intermediateViews.count {
                intermediateViews[i].removeFromSuperview()
                
                fromViews[i].alpha = 1
                toViews[i].alpha = 1
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
}
