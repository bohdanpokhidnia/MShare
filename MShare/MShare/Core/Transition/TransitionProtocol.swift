//
//  TransitionProtocol.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.04.2023.
//

import UIKit

@objc protocol TransitionProtocol {
    var transitionView: UIView { get }
    
    func viewsToAnimate() -> [UIView]
    func copyForView(_ subView: UIView) -> UIView
    
    @objc optional func resizableTransitions() -> [ResizableTransition]
    @objc optional func copyViewForCustomAnimation(_ subView: UIView) -> UIView
    
    @objc optional func frameForView(_ subView: UIView) -> CGRect
}

class ResizableTransition: NSObject {
    let view: UIView
    let from: CGRect
    let to: CGRect
    
    init(view: UIView, from: CGRect, to: CGRect) {
        self.view = view
        self.from = from
        self.to = to
    }
}
