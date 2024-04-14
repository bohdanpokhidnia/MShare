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
    
    var contentColor = UIColor { (trait) in
        switch trait.userInterfaceStyle {
        case .dark: .white
        default: UIColor(red: 88 / 255, green: 87 / 255, blue: 88 / 255, alpha: 1)
        }
    }
    
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
    
    func removeOtherAlers() {
        mainView.subviews
            .filter { $0.isKind(of: AlertView.self) }
            .forEach { $0.removeFromSuperview() }
    }
    
    func setupViews() {
        if isUniqueInstance {
            removeOtherAlers()
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
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
                centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            ])
            
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
    
    func whenPresented() {
        switch configuration.position {
        case .top, .bottom:
            break
            
        case .center:
            alpha = 1.0
        }
    }
    
    func whenPresentedCompletion() {
        
    }
    
    func presentAnimation(completion: (() -> Void)?) {
        mainView.layoutIfNeeded()
        
        setupPresentation()
        
        UIView.animate(withDuration: presentationDuration, delay: 0, options: .curveEaseIn) {
            self.whenPresented()
            self.mainView.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.configuration.haptic?.notify()
            
            if let duration = self?.configuration.duration {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    self?.dismissAlert(completion: completion)
                }
            } else {
                completion?()
            }
            
            self?.whenPresentedCompletion()
        }
    }
    
    func whenDismissed() {
        switch configuration.position {
        case .top, .bottom:
            break
            
        case .center:
            alpha = .zero
        }
    }
    
    func dismissAnimation(completion: (() -> Void)?) {
        setupDismissing()
        
        UIView.animate(withDuration: dismissDuration, delay: 0, options: .curveEaseInOut) {
            self.whenDismissed()
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
            alpha = .zero
            
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

import SwiftUI

final class TestViewController: UIViewController {
    // MARK: - UI
    
    private lazy var contentStackView = makeStackView(
        axis: .vertical,
        spacing: 16
    ) (
        topToastButton,
        centerToastButton,
        bottomToastButton
    )
    
    private let topToastButton = Button()
        .setTitle("Top toast")
        .setTitleColor(.white)
        .backgroundColor(color: .black)
        .setCornerRadius(8)
    
    private let centerToastButton = Button()
        .setTitle("Center toast")
        .setTitleColor(.white)
        .backgroundColor(color: .black)
        .setCornerRadius(8)
    
    private let bottomToastButton = Button()
        .setTitle("Bottom toast")
        .setTitleColor(.white)
        .backgroundColor(color: .black)
        .setCornerRadius(8)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
        }
        
        [
            topToastButton,
            centerToastButton,
            bottomToastButton
        ].forEach { (button) in
            button.snp.makeConstraints {
                $0.height.equalTo(49)
            }
        }
        
        topToastButton.onTap {
            AlertKit.toast(title: "Top toast", position: .top(inset: UIApplication.safeAreaInsets.top))
        }
        
        centerToastButton.onTap {
            AlertKit.shortToast(title: "Center toast", icon: .done, position: .center(inset: 0))
        }
        
        bottomToastButton.onTap {
            AlertKit.toast(title: "Bottom toast", position: .bottom(inset: 0))
        }
    }
}
