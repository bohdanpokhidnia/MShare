//
//  FromBottomPushTransition.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 16.04.2023.
//

import UIKit

class FromBottomPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var operation: UINavigationController.Operation = .push
    
    init(operation: UINavigationController.Operation) {
        self.operation = operation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let isPush = operation == .push
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! TransitionProtocol
        let fromContentView = fromViewController.transitionView
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! TransitionProtocol
        let toContentView = toViewController.transitionView
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(fromViewController.transitionView)
        containerView.addSubview(toViewController.transitionView)
        
        if !isPush {
            containerView.bringSubviewToFront(fromContentView)
        }
        
        toContentView.setNeedsLayout()
        toContentView.layoutIfNeeded()

        let fromViews = fromViewController.viewsToAnimate()
        let toViews = toViewController.viewsToAnimate()
        
        assert(fromViews.count == toViews.count, "Number of elements in fromViews and toViews have to be the same.")
        
        var intermediateViews = [UIView]()
        var toFrames = [CGRect]()
        
        for i in 0 ..< fromViews.count {
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
        
        let toResizableSource = isPush ? toViewController : fromViewController
        let fromResizableSource = isPush ? fromViewController : toViewController
        let toResizableTransitions = toResizableSource.resizableTransitions?() ?? []
        let fromResizableTransitions = fromResizableSource.resizableTransitions?() ?? []
        var resizableIntermediateViews = [UIView]()
        var resizableToFrames = [CGRect]()

        for i in 0..<toResizableTransitions.count {
            let resizableTransition = toResizableTransitions[i]
            let resizableView = resizableTransition.view
            
            guard let intermediateView = toResizableSource.copyViewForResizableView?(resizableView) else {
                continue
            }
            intermediateView.frame = isPush ? fromResizableTransitions[i].from : resizableTransition.to
            containerView.insertSubview(intermediateView, at: 2)
            resizableIntermediateViews.append(intermediateView)
        
            let toFrame = isPush ? resizableTransition.to : fromResizableTransitions[i].from
            resizableToFrames.append(toFrame)
            resizableView.alpha = 0
        }
        
        if isPush {
            toContentView.frame = fromContentView.frame.offsetBy(dx: 0, dy: fromContentView.frame.size.height)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: [], animations: { () -> Void in
            if isPush {
                toContentView.frame = fromContentView.frame
            } else {
                fromContentView.frame = fromContentView.frame.offsetBy(dx: 0, dy: fromContentView.frame.size.height)
            }
            
            for i in 0..<intermediateViews.count {
                let intermediateView = intermediateViews[i]
                intermediateView.frame = toFrames[i]
            }
            
            for i in 0..<resizableIntermediateViews.count {
                let customIntermediateView = resizableIntermediateViews[i]
                customIntermediateView.frame = resizableToFrames[i]
                
                if isPush {
                    customIntermediateView.bounds = resizableToFrames[i]
                }
            }
        }) { _ in
            for i in 0..<intermediateViews.count {
                intermediateViews[i].removeFromSuperview()
                
                fromViews[i].alpha = 1
                toViews[i].alpha = 1
            }
            
            for i in 0..<resizableIntermediateViews.count {
                resizableIntermediateViews[i].removeFromSuperview()
                
                toResizableTransitions[i].view.alpha = 1
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    // MARK: - Private
    
    private let duration: TimeInterval = 0.5
}
