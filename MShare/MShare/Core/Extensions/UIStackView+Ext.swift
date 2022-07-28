//
//  UIStackView+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

func makeStackView(axis: NSLayoutConstraint.Axis,
                   distibution: UIStackView.Distribution = .fill,
                   alignment: UIStackView.Alignment = .fill,
                   spacing: CGFloat = 0.0
    ) -> (UIView...) -> UIStackView {
    return { (views: UIView...) -> UIStackView in
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = axis
        stack.distribution = distibution
        stack.alignment = alignment
        stack.spacing = spacing
        
        return stack
    }
}

func makeStackView(_ axis: NSLayoutConstraint.Axis,
                   distibution: UIStackView.Distribution = .fill,
                   alignment: UIStackView.Alignment = .fill,
                   spacing: CGFloat = 0.0
    ) -> (UIView...) -> UIStackView {
    return makeStackView(axis: axis, distibution: distibution, alignment: alignment, spacing: spacing)
}

extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
    
    func removeArrangedSubviews() {
        arrangedSubviews.forEach { removeArrangedSubview($0) }
    }
    
}
