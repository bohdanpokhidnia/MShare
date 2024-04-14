//
//  LoadingButton.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 21.09.2022.
//

import UIKit
import SnapKit

final class LoadingButton: Button {
    enum AnimationState {
        case start
        case end
    }
    
    // MARK: - UI
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
        .make {
            $0.hidesWhenStopped = true
            $0.isHidden = true
            $0.color = .white
        }
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
    
        addSubview(loadingIndicator)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Set

extension LoadingButton {
    @discardableResult
    func set(animationState: AnimationState) -> Self {
        switch animationState {
        case .start:
            titleLabel?.alpha = 0.0
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            
        case .end:
            titleLabel?.alpha = 1.0
            loadingIndicator.stopAnimating()
        }
        return self
    }
}
