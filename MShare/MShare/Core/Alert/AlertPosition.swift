//
//  AlertPosition.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 12.10.2023.
//

import Foundation

enum AlertPosition {
    case top(inset: CGFloat)
    case center(inset: CGFloat)
    case bottom(inset: CGFloat)
    
    var inset: CGFloat {
        switch self {
        case .top(let inset): inset
        case .center(let inset): inset
        case .bottom(let inset): inset
        }
    }
}
