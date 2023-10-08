//
//  AlertKitView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 08.10.2023.
//

import UIKit

class AlertKitView: UIView {
    
    // MARK: - UI
    
    private let contentStackView = UIStackView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dismissButton = UIButton(type: .system)
    
    // MARK: - Initializers
    
    init(title: String, haptic: AlertKitHaptic?) {
        self.haptic = haptic
        
        super.init(frame: .zero)
        
        setupViews(title: title)
        setupActions()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Presentation
    
    func present(on view: UIView, completion: (() -> Void)? = nil) {
        setupStartPosition(on: view, height: height)
        present(on: view)
    }
    
    // MARK: - Private
    
    private let haptic: AlertKitHaptic?
    private var topContstraint = NSLayoutConstraint()
    private var bottomConstraint = NSLayoutConstraint()
    private let height: CGFloat = 49.0
    private let bottomInset: CGFloat = 26.0
    
}

// MARK: - Setup

private extension AlertKitView {
    
    func setupViews(title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8.0
        backgroundColor = .red
        
        contentStackView.axis = .horizontal
        contentStackView.distribution = .fill
        contentStackView.alignment = .center
        contentStackView.spacing = 8
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(dismissButton)
        
        iconImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .yellow
        
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14)
        
        dismissButton.setTitle("Okay", for: .normal)
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 21),
            iconImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0)
        ])
        
        NSLayoutConstraint.activate([
            dismissButton.widthAnchor.constraint(equalToConstant: 78)
        ])
    }
    
    func setupActions() {
        dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
    }
    
    func setupStartPosition(on view: UIView, height: CGFloat) {
        view.addSubview(self)
        topContstraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: height)

        NSLayoutConstraint.activate([
            topContstraint,
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
}

// MARK: - User interactions

private extension AlertKitView {
    
    @objc
    func didTapDismissButton() {
        dismiss()
    }
    
}

// MARK: - Private Methods

private extension AlertKitView {
    
}

// MARK: - Animations

private extension AlertKitView {
    
    func present(on view: UIView) {
        let presentedConstant = height + bottomInset
        superview?.layoutIfNeeded()
        
        topContstraint.isActive = false
        bottomConstraint = bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -presentedConstant)
        bottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.superview?.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.haptic?.notify()
        }
    }
    
    func dismiss() {
        bottomConstraint.isActive = false
        topContstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.superview?.layoutIfNeeded()
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
}
