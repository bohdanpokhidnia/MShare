//
//  GradientView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 17.08.2022.
//

import UIKit

final class GradientView: ViewLayoutable {
    // MARK: - Override property
    
    override var bounds: CGRect {
        didSet {
            gradientLayer.frame = bounds
        }
    }
    
    // MARK: - Private
    
    private var colors = [CGColor]()
    
    private lazy var gradientLayer = CAGradientLayer()
        .make {
            $0.colors = colors
            $0.zPosition = -1000
            
            layer.insertSublayer($0, at: 0)
        }
}

// MARK: - Set

extension GradientView {
    @discardableResult
    func set(colors: [UIColor]) -> Self {
        self.colors = colors.map { $0.cgColor }
        return self
    }
    
    @discardableResult
    func set(startPoint: GradientDirection, endPoint: GradientDirection) -> Self {
        gradientLayer.startPoint = startPoint.point
        gradientLayer.endPoint = endPoint.point
        return self
    }
}
