//
//  AlertKitIconErrorView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 16.04.2024.
//

import UIKit

class AlertKitIconErrorView: UIView {
    private let lineThick: CGFloat
    
    init(lineThick: CGFloat) {
        self.lineThick = lineThick
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private var completion: (() -> Void)?
}

// MARK: - Animations

private extension AlertKitIconErrorView {
    func animateTopToBottomLine() {
        let length = frame.width
        
        let topToBottomLine = UIBezierPath()
        topToBottomLine.move(to: CGPoint(x: length * 0, y: length * 0))
        topToBottomLine.addLine(to: CGPoint(x: length * 1, y: length * 1))
        
        let animatableLayer = CAShapeLayer()
        animatableLayer.path = topToBottomLine.cgPath
        animatableLayer.fillColor = UIColor.clear.cgColor
        animatableLayer.strokeColor = tintColor?.cgColor
        animatableLayer.lineWidth = lineThick
        animatableLayer.lineCap = .round
        animatableLayer.lineJoin = .round
        animatableLayer.strokeEnd = 0
        self.layer.addSublayer(animatableLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.22
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        animatableLayer.strokeEnd = 1
        animatableLayer.add(animation, forKey: "animation")
    }
        
    func animateBottomToTopLine() {
        let length = frame.width
        
        let bottomToTopLine = UIBezierPath()
        bottomToTopLine.move(to: CGPoint(x: length * 0, y: length * 1))
        bottomToTopLine.addLine(to: CGPoint(x: length * 1, y: length * 0))
        
        let animatableLayer = CAShapeLayer()
        animatableLayer.path = bottomToTopLine.cgPath
        animatableLayer.fillColor = UIColor.clear.cgColor
        animatableLayer.strokeColor = tintColor?.cgColor
        animatableLayer.lineWidth = lineThick
        animatableLayer.lineCap = .round
        animatableLayer.lineJoin = .round
        animatableLayer.strokeEnd = 0
        self.layer.addSublayer(animatableLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.22
        animation.fromValue = 0
        animation.toValue = 1
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        animatableLayer.strokeEnd = 1
        animatableLayer.add(animation, forKey: "animation")
    }
}

//MARK: - CAAnimationDelegate

extension AlertKitIconErrorView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completion?()
    }
}

//MARK: - AlertKitIconAnimatable

extension AlertKitIconErrorView: AlertKitIconAnimatable {
    func animate(completion: (() -> Void)?) {
        self.completion = completion
        
        animateTopToBottomLine()
        animateBottomToTopLine()
    }
}
