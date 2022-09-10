//
//  Button.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 03.08.2022.
//

import UIKit

final class Button: UIButton {
    private var didTapAction: (() -> Void) = { }
}

// MARK: - User interactions

private extension Button {
    
    @objc
    func tapButton(_ button: UIButton) {
        didTapAction()
    }
    
}

// MARK: - Set

extension Button {
    
    @discardableResult
    func whenTap(action: @escaping () -> Void) -> Self {
        didTapAction = action
        addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        
        return self
    }
    
    @discardableResult
    func setImage(_ image: UIImage?, forState state: UIControl.State = .normal) -> Self {
        setImage(image, for: state)
        
        return self
    }
    
    @discardableResult
    func setTitle(_ title: String, forState state: UIControl.State = .normal) -> Self {
        setTitle(title, for: state)
        
        return self
    }
    
}
