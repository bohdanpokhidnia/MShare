//
//  SignInCollectionViewCell.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 05.02.2023.
//

import UIKit

final class SignInCollectionViewCell: CollectionViewCell {
    struct State {
        let image: UIImage?
        let title: String
        let subtitle: String
    }
    
    // MARK: - UI
    
    private lazy var contentStackView = makeStackView(
        axis: .horizontal,
        spacing: 16
    )(
        emojiView, textContainerView
    )
    
    private let emojiView = ViewLayoutable()
        .backgroundColor(color: .label)
        .setCornerRadius(8)
        .maskToBounds(true)
    
    private let imageView = UIImageView()
        .setContentMode(.center)
        .backgroundColor(color: .systemBackground)
        .setCornerRadius(6)
        .maskToBounds(true)
    
    private let textContainerView = ViewLayoutable()
    
    private lazy var textStackView = makeStackView(
        axis: .vertical,
        spacing: 4
    )(
        titleLabel,
        subtitleLabel
    )
    
    private let titleLabel = UILabel()
        .text(font: .systemFont(ofSize: 16, weight: .medium))
    
    private let subtitleLabel = UILabel()
        .text(font: .preferredFont(forTextStyle: .subheadline))
        .textColor(.secondaryLabel)
        .set(numberOfLines: 2)
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
        
        emojiView.addSubview(imageView)
        textContainerView.addSubview(textStackView)
        addSubview(contentStackView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emojiView.snp.makeConstraints {
            $0.width.equalTo(60)
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(56)
        }
        
        textStackView.snp.makeConstraints {
            $0.centerY.leading.trailing.equalToSuperview()
        }
    }
}

//MARK: - Set

extension SignInCollectionViewCell {
    @discardableResult
    func set(state: State) -> Self {
        imageView.image = state.image
        titleLabel.text = state.title
        subtitleLabel.text = state.subtitle
        return self
    }
}
