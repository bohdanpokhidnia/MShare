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
                return 0.2
                
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
        
        switch animationState {
        case .start:
            titleLabel?.alpha = 0
            
        case .end:
            break
        }
        
        UIView.animate(withDuration: animationState.duration, animations: {
            self.frame = finalFrame
            self.bounds = finalFrame
            self.setCornerRadius(cornerRadius)
            
            switch animationState {
            case .start:
                self.loadingIndicator.startAnimating()
                self.loadingIndicator.isHidden = false
                
            case .end:
                break
            }
            
        }) { _ in
            UIView.animate(withDuration: 0.35) {
                switch animationState {
                case .start:
                    break
                    
                case .end:
                    self.titleLabel?.alpha = 1
                    self.loadingIndicator.stopAnimating()
                }
            } completion: { _ in
                completion?()
            }
        }
        
        return self
    }
    
}
