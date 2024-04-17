//
//  GradientDirection.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 17.04.2024.
//

import Foundation

enum GradientDirection {
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

extension GradientDirection {
    func point(for size: CGSize, flipped: Bool = false) -> CGPoint {
        var point: CGPoint = switch self {
        case .topLeading: CGPoint(x: 0, y: 0)
        case .leading: CGPoint(x: 0, y: size.height / 2)
        case .bottomLeading: CGPoint(x: 0, y: size.height)
        case .top: CGPoint(x: size.width / 2, y: 0)
        case .center: CGPoint(x: size.width / 2, y: size.height / 2)
        case .bottom: CGPoint(x: size.width / 2, y: size.height)
        case .topTrailing: CGPoint(x: size.width, y: 0)
        case .trailing: CGPoint(x: size.width, y: size.height / 2)
        case .bottomTrailing: CGPoint(x: size.width, y: size.height)
        }
        
        if flipped {
            point.y = size.height - point.y
        }
        
        return point
    }
}
