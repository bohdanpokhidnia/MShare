//
//  GradientView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 17.08.2022.
//

import UIKit

enum GradientPoint {
    case topLeading
    case leading
    case bottomLeading
    case top
    case center
    case bottom
    case topTrailing
    case trailing
    case bottomTrailing
    
    var point: CGPoint {
        switch self {
        case .topLeading:
            return .init(x: 0, y: 0)
            
        case .leading:
            return .init(x: 0, y: 0.5)
            
        case .bottomLeading:
            return .init(x: 0, y: 1.0)
            
        case .top:
            return .init(x: 0.5, y: 0)
            
        case .center:
            return .init(x: 0.5, y: 0.5)
            
        case .bottom:
            return .init(x: 0.5, y: 1.0)
            
        case .topTrailing:
            return .init(x: 1.0, y: 0)
            
        case .trailing:
            return .init(x: 1.0, y: 0.5)
            
        case .bottomTrailing:
            return .init(x: 1.0, y: 1.0)
        }
    }
}

final class GradientView: ViewLayoutable {
    // MARK: - Override property
    
    override var bounds: CGRect {
        didSet { gradientLayer.frame = bounds }
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
    func set(startPoint: GradientPoint, endPoint: GradientPoint) -> Self {
        gradientLayer.startPoint = startPoint.point
        gradientLayer.endPoint = endPoint.point
        
        return self
    }
}
