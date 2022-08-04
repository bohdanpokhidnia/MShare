//
//  UILabel+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 03.08.2022.
//

import UIKit

extension UILabel {
    
    @discardableResult
    func text(_ aText: String?) -> Self {
        self.text = aText
        return self
    }
    
    @discardableResult
    func text(font aFont: UIFont) -> Self {
        font = aFont
        return self
    }
    
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        textColor = color
        return self
    }
    
    @discardableResult
    func text(alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }
    
    @discardableResult
    func enableMultilines() -> Self {
        numberOfLines = 0
        return self
    }
    
    @discardableResult
    func set(numberOfLines lines: Int) -> Self {
        numberOfLines = lines
        return self
    }
    
}
