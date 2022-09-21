//
//  PaddedTextField.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 21.09.2022.
//

import UIKit

final class PaddedTextField: UITextField {
    
    public var textInsets = UIEdgeInsets.zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var borderColor: UIColor? = UIColor.clear {
        didSet {
            layer.borderColor = self.borderColor?.cgColor
        }
    }

    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    var customCornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = customCornerRadius
            layer.masksToBounds = customCornerRadius > 0
        }
    }
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Override methods
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
        
        self.layer.cornerRadius = customCornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
    }
    
}
