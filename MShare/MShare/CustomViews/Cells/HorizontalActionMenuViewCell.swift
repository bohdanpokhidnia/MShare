//
//  HorizontalActionMenuViewCell.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 11.08.2022.
//

import UIKit
import SnapKit

typealias HorizontalActionAnimationType = HorizontalActionMenuViewCell.Style

final class HorizontalActionMenuViewCell: CollectionViewCell {
    
    enum Style {
        case blurred
        case normal
        
        var animation: CGAffineTransform {
            switch self {
            case .blurred:
                return .identity.scaledBy(x: 0.95, y: 0.95)
                
            case .normal:
                return .identity
            }
        }
    }
   
    struct State {
        let image: UIImage?
        let title: String
    }
    
    // MARK: - UI
    
    private let containerView = View()
    
    private let actionImageView = UIImageView()
        .setContentMode(.scaleAspectFill)
        .backgroundColor(color: .systemBlue)
    
    private let actionTitleLabel = UILabel()
        .text(alignment: .center)
        .text(font: UIFont.systemFont(ofSize: 18, weight: .medium))
        .textColor(.white)
        .set(numberOfLines: 1)
        .adjustsFontSizeToFitWidth(true)
    
    private let blurredView = View()
        .addBlur(style: .regular)
        .setAlpha(0)
    
    private lazy var loadingStackView = makeStackView(
        axis: .vertical,
        spacing: 10
    )(
        loadingIndicator,
        loadingLabel
    )
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
        .make {
            $0.hidesWhenStopped = true
        }
    
    private let loadingLabel = UILabel()
        .text("Loading")
        .text(alignment: .center)
        .text(font: UIFont.systemFont(ofSize: 18, weight: .medium))
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        setCornerRadius(cellCornerRadius)
        maskToBounds(true)
        
        loadingStackView.setAlpha(0)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        containerView.addSubviews(actionImageView,
                                  actionTitleLabel,
                                  blurredView,
                                  loadingStackView)
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

        actionTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 5))
            $0.bottom.equalToSuperview().offset(-3)
        }
        
        blurredView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

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
        return self
    }
    
    @discardableResult
    func set(style: Style) -> Self {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 5,
                       options: [.allowUserInteraction],
                       animations: {
            
            self.transform = style.animation
            
            switch style {
            case .blurred:
                self.loadingIndicator.startAnimating()
                self.blurredView.setAlpha(1)
                self.loadingStackView.setAlpha(1)
                
            case .normal:
                self.loadingIndicator.stopAnimating()
                self.blurredView.setAlpha(0)
                self.loadingStackView.setAlpha(0)
            }
            
        })
        
        return self
    }
    
}
