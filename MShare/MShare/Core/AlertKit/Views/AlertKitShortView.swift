//
//  AlertKitShortView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 19.10.2023.
//

import UIKit

final class AlertKitShortView: UIView {
    var contentColor = UIColor { (trait) in
        switch trait.userInterfaceStyle {
        case .dark: .white
        default: UIColor(red: 88.0 / 255.0, green: 87.0 / 255.0, blue: 88.0 / 255.0, alpha: 1.0)
        }
    }
    
    // MARK: - UI
    
    private lazy var backgroundView: UIView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(titleLabel)
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = contentColor
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let iconView: UIView
    
    // MARK: - Initializers
    
    init(
        title: String,
        icon: AlertKitIcon,
        on mainView: UIView,
        configuration: AlertConfiguration
    ) {
        self.iconView = icon.createView(lineThick: 3.0)
        self.iconView.tintColor = contentColor
        self.mainView = mainView
        self.configuration = configuration
        
        super.init(frame: .zero)
        
        setup()
        setupViews(title: title)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Animations
    
    func present() {
        configuration.haptic?.notify()
        
        UIView.animate(withDuration: configuration.presentationDuration) {
            self.alpha = 1.0
        } completion: { [weak self] _ in
            self?.whenPresentedCompletion()
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: configuration.dismissDuration) {
            self.alpha = .zero
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
    
    // MARK: - Private
    
    private let mainView: UIView
    private let configuration: AlertConfiguration
}

// MARK: - Setup

private extension AlertKitShortView {
    func setup() {
        let isUseSafeArea = configuration.isUseSafeArea
        alpha = .zero
        translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(self)
        
        switch configuration.position {
        case .top:
            if let inset = configuration.inset {
                topAnchor.constraint(equalTo: isUseSafeArea ? mainView.safeAreaLayoutGuide.topAnchor : mainView.topAnchor, constant: inset).isActive = true
            } else {
                topAnchor.constraint(equalTo: isUseSafeArea ? mainView.safeAreaLayoutGuide.topAnchor : mainView.topAnchor).isActive = true
            }
            
        case .center:
            if let inset = configuration.inset {
                centerYAnchor.constraint(equalTo: isUseSafeArea ? mainView.safeAreaLayoutGuide.centerYAnchor : mainView.centerYAnchor, constant: inset).isActive = true
            } else {
                centerYAnchor.constraint(equalTo: isUseSafeArea ? mainView.safeAreaLayoutGuide.centerYAnchor : mainView.centerYAnchor).isActive = true
            }
            
        case .bottom:
            if let inset = configuration.inset {
                bottomAnchor.constraint(equalTo: isUseSafeArea ? mainView.safeAreaLayoutGuide.bottomAnchor : mainView.bottomAnchor, constant: inset).isActive = true
            } else {
                bottomAnchor.constraint(equalTo: isUseSafeArea ? mainView.safeAreaLayoutGuide.bottomAnchor : mainView.bottomAnchor).isActive = true
            }
            
        case .custom(let y):
            topAnchor.constraint(equalTo: mainView.topAnchor, constant: y).isActive = true
        }
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: isUseSafeArea ? mainView.safeAreaLayoutGuide.centerXAnchor : mainView.centerXAnchor),
            heightAnchor.constraint(equalToConstant: configuration.height)
        ])
    }
    
    func setupViews(title: String) {
        addSubview(backgroundView)
        addSubview(contentStackView)
    
        titleLabel.text = title
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}

// MARK: - Private Methods

private extension AlertKitShortView {
    func whenPresentedCompletion() {
        guard let anitableIconView = iconView as? AlertKitIconAnimatable else {
            didPresentAlert()
            return
        }
        
        anitableIconView.animate(completion: { [weak self] in
            self?.didPresentAlert()
        })
    }
    
    func didPresentAlert() {
        guard let displayDuration = configuration.displayDuration else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + displayDuration) { [weak self] in
            self?.dismiss()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    let linkView = SearchView()
    linkView.contentView.linkTextField.text = "Test"
    linkView.contentView.searchButton.onTap {
        AlertKitShortView(
//            title: "The url field is not a valid fully-qualified http, https, or ftp URL",
            title: "Oops",
            icon: .heart,
            on: linkView.contentView,
            configuration: .init(
                position: .custom(y: 250),
//                position: .bottom,
                height: 50,
                displayDuration: 1.3
            )
        )
        .present()
    }
    
    return linkView
}
