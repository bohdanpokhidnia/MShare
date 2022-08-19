//
//  GradientView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 17.08.2022.
//

import UIKit

final class GradientView: View {
    
    // MARK: - Override property
    
    override var bounds: CGRect {
        didSet { gradientLayer.frame = bounds }
    }
    
    // MARK: - Private
    
    private var colors = [CGColor]()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint =  CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = colors
        gradientLayer.zPosition = -1000
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }()

}

// MARK: - Set

extension GradientView {
    
    @discardableResult
    func set(colors: [UIColor]) -> Self {
        self.colors = colors.map { $0.cgColor }
        return self
    }
    
}
