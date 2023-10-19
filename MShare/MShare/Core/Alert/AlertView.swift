//
//  AlertView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 12.10.2023.
//

import UIKit

class AlertView: UIView {
    let mainView: UIView
    let configuration: AlertConfiguration
    
    var presentationDuration: CGFloat { 0.3 }
    var dismissDuration: CGFloat { 0.5 }
    var isUniqueInstance: Bool { true }
    
    // MARK: - Initializers
    
    init(
        view: UIView,
        configuration: AlertConfiguration
    ) {
        self.mainView = view
        self.configuration = configuration
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func removeOtherInstances() {
        mainView.subviews
            .filter { $0.isKind(of: AlertView.self) }
            .forEach { $0.removeFromSuperview() }
    }
    
    func setupViews() {
        if isUniqueInstance {
            removeOtherInstances()
        }
        
        mainView.addSubview(self)
        
        let leadingInset: CGFloat = configuration.insets?.left ?? .zero
        let trailingInset: CGFloat = configuration.insets?.right ?? .zero
        
        switch configuration.position {
        case .top:
            bottomConstraint = topAnchor.constraint(
                equalTo: mainView.topAnchor,
                constant: -configuration.height
            )
            bottomConstraint.isActive = true
            
        case .center:
            break
            
        case .bottom:
            topContstraint = topAnchor.constraint(equalTo: mainView.bottomAnchor)
            topContstraint.isActive = true
        }
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(
                equalTo: mainView.leadingAnchor,
                constant: leadingInset
            ),
            trailingAnchor.constraint(
                equalTo: mainView.trailingAnchor,
                constant: -trailingInset
            ),
            heightAnchor.constraint(equalToConstant: configuration.height),
        ])
    }
    
    // MARK: - Animations
    
    func presentAnimation(completion: (() -> Void)?) {
        mainView.layoutIfNeeded()
        
        setupPresentation()
        
        UIView.animate(withDuration: presentationDuration, delay: 0, options: .curveEaseIn) {
            self.mainView.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.configuration.haptic?.notify()
            completion?()
        }
    }
    
    func dismissAnimation(completion: (() -> Void)?) {
        setupDismissing()
        
        UIView.animate(withDuration: dismissDuration, delay: 0, options: .curveEaseInOut) {
            self.mainView.layoutIfNeeded()
        } completion: { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
    
    // MARK: - Presentation
    
    func presentAlert(completion: (() -> Void)? = nil) {
        setupViews()
        presentAnimation(completion: completion)
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
    
    func setupPresentation() {
        let positionInset = configuration.position.inset
        let configurationInsets = configuration.insets
        
        switch configuration.position {
        case .top:
            let topInset: CGFloat = positionInset + (configurationInsets?.top ?? .zero)
            
            bottomConstraint.isActive = false
            topContstraint = topAnchor.constraint(
                equalTo: mainView.topAnchor,
                constant: topInset
            )
            topContstraint.isActive = true
            
        case .center:
            break
            
        case .bottom:
            let bottomInset: CGFloat = positionInset + (configurationInsets?.bottom ?? .zero)
            
            topContstraint.isActive = false
            bottomConstraint = bottomAnchor.constraint(
                equalTo: mainView.bottomAnchor,
                constant: -bottomInset
            )
            bottomConstraint.isActive = true
        }
    }
    
    func setupDismissing() {
        switch configuration.position {
        case .top:
            topContstraint.isActive = false
            bottomConstraint.isActive = true
            
        case .center:
            break
            
        case .bottom:
            bottomConstraint.isActive = false
            topContstraint.isActive = true
        }
    }
    
}
