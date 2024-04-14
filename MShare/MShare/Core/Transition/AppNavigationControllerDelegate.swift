//
//  AppNavigationControllerDelegate.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.04.2023.
//

import UIKit

class AppNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    var interactiveTransition: UIPercentDrivenInteractiveTransition?
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var transition: UIViewControllerAnimatedTransitioning?
        
        switch (fromVC, toVC) {
        case (is FavoritesView, is DetailSongView):
            transition = FromBottomPushTransition(operation: .push)
        
        case (is DetailSongView, is FavoritesView):
            transition = FromBottomPushTransition(operation: .pop)
            
        case (is LinkView, is DetailSongView):
            transition = BottomPushTransition()
            
        case (is DetailSongView, is LinkView):
            transition = BottomPopTransition()
            
        default:
            return nil
        }
        
        return transition
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}
