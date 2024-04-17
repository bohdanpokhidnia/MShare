//
//  HorizontalActionMenuViewCell.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 11.08.2022.
//

import UIKit
import SnapKit

typealias HorizontalActionMenuItem = HorizontalActionMenuViewCell.State
typealias HorizontalActionAnimationType = HorizontalActionMenuViewCell.Style

final class HorizontalActionMenuViewCell: CollectionViewCell {
    enum Style {
        case blurred
        case normal
        
        var animation: CGAffineTransform {
            switch self {
            case .blurred:
                return .identity.scaledBy(x: 0.98, y: 0.98)
                
            case .normal:
                return .identity
            }
        }
    }
   
    struct State {
        let action: HorizontalMenuAction
        let image: UIImage?
        let title: String
        let active: Bool
        
        init(horizontalMenuAction: HorizontalMenuAction, available: Bool) {
            action = horizontalMenuAction
            image = action.image
            title = action.title
            active = available
        }
    }
    
    // MARK: - UI
    
    private let containerView = ViewLayoutable()
    
    private let actionImageView = UIImageView()
        .setContentMode(.scaleAspectFill)
        .backgroundColor(color: .systemBlue)
    
    private let backgroundShadowGradientView = GradientView()
        .set(colors: [.clear, .black.withAlphaComponent(0.3)])
        .set(startPoint: .top, endPoint: .bottom)
    
    private let shareCircleView = ShareCircleView()
        .setCornerRadius(15)
        .maskToBounds(true)
    
    private let actionTitleLabel = Label()
        .text(alignment: .center)
        .text(font: UIFont.systemFont(ofSize: 18, weight: .medium))
        .textColor(.white)
        .set(characterSpacing: 1.1)
        .set(numberOfLines: 1)
        .adjustsFontSizeToFitWidth(true)
    
    private let blurredView = ViewLayoutable()
        .addBlur(style: .light, intensity: 0.25)
        .setAlpha(0)
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
        .make {
            $0.hidesWhenStopped = true
        }

    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        contentView.layer.cornerRadius = cellCornerRadius
        contentView.layer.masksToBounds = true

        layer.cornerRadius = cellCornerRadius
        layer.masksToBounds = false
        
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 4, height: 4)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        containerView.addSubviews(
            actionImageView,
            backgroundShadowGradientView,
            shareCircleView,
            actionTitleLabel,
            blurredView,
            loadingIndicator
        )
        contentView.addSubview(containerView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        actionImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundShadowGradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        shareCircleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.width.height.equalTo(30)
        }

        actionTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 5))
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        blurredView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Override methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cellCornerRadius).cgPath
    }
    
    // MARK: - Private
    
    private let cellCornerRadius: CGFloat = 12
    
}

// MARK: - Set

extension HorizontalActionMenuViewCell {
    @discardableResult
    func set(state: State) -> Self {
        actionImageView.setImage(state.image)
        actionTitleLabel.text(state.title)
        blurredView.setAlpha(state.active ? 0 : 0.8)
        return self
    }
    
    @discardableResult
    func set(style: Style) -> Self {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 5,
            options: [.allowUserInteraction],
            animations: {
                self.transform = style.animation
                
                switch style {
                case .blurred:
                    self.loadingIndicator.startAnimating()
                    self.blurredView.setAlpha(0.8)
                    
                case .normal:
                    self.loadingIndicator.stopAnimating()
                    self.blurredView.setAlpha(0)
                }
            }
        )
        return self
    }
}
