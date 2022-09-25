//
//  LoadingButton.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 21.09.2022.
//

import UIKit

final class LoadingButton: Button {
    
    enum AnimationState {
        case start
        case end
        
        var duration: CGFloat {
            switch self {
            case .start:
                return 0.3
                
            case .end:
                return 0.2
            }
        }
    }
    
    // MARK: - UI
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
        .make {
            $0.hidesWhenStopped = true
            $0.isHidden = true
            $0.color = .white
        }
    
    // MARK: - Override methods
    
    override var frame: CGRect {
        didSet {
            defineLayout()
        }
    }
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
    
        addSubview(loadingIndicator)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        loadingIndicator.frame.origin = .init(x: center.x - loadingIndicator.frame.width / 2, y: center.y - loadingIndicator.frame.height / 2)
    }
    
}

// MARK: - Set

extension LoadingButton {
    
    @discardableResult
    func set(animationState: AnimationState, finalFrame: CGRect, cornerRadius: CGFloat = 0, completion: (() -> Void)? = nil) -> Self {
        UIView.animate(withDuration: animationState.duration, animations: {
            switch animationState {
            case .start:
                self.titleLabel?.alpha = 0
                self.loadingIndicator.startAnimating()
                self.loadingIndicator.isHidden = false
                
            case .end:
                self.titleLabel?.alpha = 1
                self.loadingIndicator.stopAnimating()
            }
            
            self.frame = finalFrame
            self.setCornerRadius(cornerRadius)
            
        }) { _ in
            completion?()
        }
        
        return self
    }
    
}
