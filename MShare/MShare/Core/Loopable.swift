//
//  Loopable.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 16.10.2022.
//

import Foundation

protocol Loopable {
    func allPropertiesCount() -> Int
    func item<T>(type: T.Type, atIndex index: Int) -> T?
}

extension Loopable {
    
    func allPropertiesCount() -> Int {
        let mirror = Mirror(reflecting: self)
        
        return mirror.children.count
    }
    
    func item<T>(type: T.Type, atIndex index: Int) -> T? {
        let mirror = Mirror(reflecting: self)
        let children = mirror.children
        
        guard let style = mirror.displayStyle, style == .struct || style == .class,
              let indexItem = children.index(children.startIndex, offsetBy: index, limitedBy: children.endIndex)
        else { return nil }
        
        let item = children[indexItem].value
        return item as? T
    }
    
}
