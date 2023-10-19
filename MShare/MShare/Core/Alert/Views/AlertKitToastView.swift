//
//  AlertKitToastView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 08.10.2023.
//

import UIKit

class AlertKitToastView: AlertView {
    // MARK: - UI
    
    private let contentStackView = UIStackView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dismissButton = UIButton(type: .system)
    
    // MARK: - Initializers
    
    init(
        title: String,
        view: UIView,
        configutation: AlertConfiguration
    ) {
        super.init(view: view, configuration: configutation)
        
        setupViews(title: title)
        setupActions()
    }
    
}

// MARK: - Setup

private extension AlertKitToastView {
    
    func setupViews(title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8.0
        backgroundColor = .red
        
        contentStackView.axis = .horizontal
        contentStackView.distribution = .fill
        contentStackView.alignment = .center
        contentStackView.spacing = 8.0
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
    
}

// MARK: - User interactions

private extension AlertKitToastView {
    
    @objc
    func didTapDismissButton() {
        dismissAlert()
    }
    
}
