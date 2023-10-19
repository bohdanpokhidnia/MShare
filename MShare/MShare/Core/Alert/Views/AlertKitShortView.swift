//
//  AlertKitShortView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 19.10.2023.
//

import UIKit

class AlertKitShortView: AlertView {
    // MARK: - UI
    
    private lazy var backgroundView: UIView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        return view
    }()
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()
    
    // MARK: - Override properties
    
    override var presentationDuration: CGFloat { 0.5 }
    
    // MARK: - Override methods
    
    override func setupViews() {
        mainView.addSubview(self)
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            heightAnchor.constraint(equalToConstant: configuration.height),
        ])
    }
    
    // MARK: - Initializers
    
    init(
        title: String,
        view: UIView,
        configuration: AlertConfiguration
    ) {
        super.init(view: view, configuration: configuration)
        
        setupViews(title: title)
    }
}

// MARK: - Setup

private extension AlertKitShortView {
    func setupViews(title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        contentStackView.axis = .horizontal
        contentStackView.distribution = .fill
        contentStackView.alignment = .center
        contentStackView.spacing = 8.0
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(iconImageView)
        
        iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = contentColor
        
        titleLabel.text = title
        titleLabel.textColor = contentColor
        titleLabel.font = .systemFont(ofSize: 14)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 21),
            iconImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0)
        ])
    }
}
