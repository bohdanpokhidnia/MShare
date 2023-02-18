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
    
    @discardableResult
    func adjustsFontSizeToFitWidth(_ toFitWitdth: Bool) -> Self {
        adjustsFontSizeToFitWidth = toFitWitdth
        return self
    }
    
    func setLineHeight(lineHeight: CGFloat) {
        guard let text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        
        style.lineSpacing = lineHeight
        attributeString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: style,
            range: NSMakeRange(0, attributeString.length))
        
        attributedText = attributeString
    }
    
}

//MARK: - UIComponentsLibrary

extension UILabel {
    
    @discardableResult
    func set(component: UIComponentsLibrary.TextComponent) -> Self {
        text(font: component.font)
        textColor(component.color)
        return self
    }
    
}
