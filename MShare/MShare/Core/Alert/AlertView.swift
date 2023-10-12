//
//  AlertView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 12.10.2023.
//

import UIKit

class AlertView: UIView {
    let configuration: AlertConfiguration
    
    // MARK: - Initializers
    
    init(configuration: AlertConfiguration) {
        self.configuration = configuration
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupStartPosition(on view: UIView) {
        view.addSubview(self)
        
        let leadingInset: CGFloat = configuration.insets?.left ?? .zero
        let trailingInset: CGFloat = configuration.insets?.right ?? .zero
        
        switch configuration.position {
        case .top:
            break
            
        case .center:
            break
            
        case .bottom:
            topContstraint = topAnchor.constraint(equalTo: view.bottomAnchor)
            topContstraint.isActive = true
            
        case .custom(_):
            break
        }
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: leadingInset
            ),
            trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -(trailingInset)
            ),
            heightAnchor.constraint(equalToConstant: configuration.height),
        ])
    }
    
    // MARK: - Animations
    
    func presentAnimation(on view: UIView, completion: (() -> Void)?) {
        superview?.layoutIfNeeded()
        
        setupPresentetaion(for: view)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.superview?.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.configuration.haptic?.notify()
            completion?()
        }
    }
    
    func dismissAnimation(completion: (() -> Void)?) {
        setupDismissing()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.superview?.layoutIfNeeded()
        } completion: { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
    
    // MARK: - Presentation
    
    func presentAlert(on view: UIView, completion: (() -> Void)? = nil) {
        setupStartPosition(on: view)
        presentAnimation(on: view, completion: completion)
    }
    
    func dismissAlert(completion: (() -> Void)? = nil) {
        dismissAnimation(completion: completion)
    }
    
    // MARK: - Private
    
    private var topContstraint = NSLayoutConstraint()
    private var bottomConstraint = NSLayoutConstraint()
}

// MARK: - Private Methods

private extension AlertView {
    
    func setupPresentetaion(for view: UIView) {
        switch configuration.position {
        case .top:
            break
            
        case .center:
            break
            
        case .bottom(let inset):
            let bottomInset: CGFloat = inset + (configuration.insets?.bottom ?? .zero)
            
            topContstraint.isActive = false
            bottomConstraint = bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -bottomInset
            )
            bottomConstraint.isActive = true
            
        case .custom(let origin):
            break
        }
    }
    
    func setupDismissing() {
        switch configuration.position {
        case .top:
            break
            
        case .center:
            break
            
        case .bottom:
            bottomConstraint.isActive = false
            topContstraint.isActive = true
            
        case .custom(let origin):
            break
        }
    }
    
}
