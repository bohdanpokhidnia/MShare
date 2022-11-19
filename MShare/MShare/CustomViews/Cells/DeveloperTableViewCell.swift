//
//  DeveloperTableViewCell.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 23.10.2022.
//

import UIKit

final class DeveloperTableViewCell: TableViewCell {
    
    struct State {
        let name: String
        let avatar: UIImage?
        let instagram: Instagram
    }
    
    struct Instagram {
        let name: String
        let link: String
    }
    
    // MARK: - UI
    
    private let contentContainerView = View()
    
    private lazy var contentStackView = makeStackView(
        axis: .horizontal,
        spacing: 10
    )(
        avatarImageView,
        nameStackView
    )
    
    private lazy var nameStackView = makeStackView(
        axis: .vertical,
        distibution: .fillProportionally,
        spacing: 10
    )(
        nameContainer,
        roleContainer
    )
    
    private lazy var instagramStackView = makeStackView(
        axis: .horizontal,
        spacing: 14
    )(
        instagramLabel, instagramTextView
    )
    
    private let avatarImageView = UIImageView()
        .setContentMode(.scaleAspectFill)
        .backgroundColor(color: .purple)
        .setCornerRadius(10)
        .maskToBounds(true)
    
    private let nameContainer = View()
    
    private let nameLabel = UILabel()
        .make {
            $0.set(numberOfLines: 2)
            $0.lineBreakMode = .byWordWrapping
        }
    
    private let roleContainer = View()
    
    private let roleLabel = UILabel()
        .make {
            $0.text = "Developer"
        }
    
    private let instagramLabel = UILabel()
        .text("Instagram:")
    
    private let instagramTextView = UITextView()
        .make {
            $0.contentInsetAdjustmentBehavior = .always
            $0.textAlignment = .center
            $0.isEditable = false
            $0.isScrollEnabled = false
        }
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        selectionStyle = .none
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        nameContainer.addSubview(nameLabel)
        roleContainer.addSubview(roleLabel)
        contentContainerView.addSubview(contentStackView)
        contentView.addSubview(contentContainerView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        contentContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(all: 16))
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.width.equalTo(80)
        }
        
        roleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
    }
    
}

// MARK: - Set

extension DeveloperTableViewCell {
    
    @discardableResult
    func set(state: State) -> Self {
        avatarImageView.image = state.avatar
        nameLabel
            .text(state.name)
            .setLineHeight(lineHeight: 5)
        setupInstagramTextView(instagram: state.instagram)
        return self
    }
    
}

// MARK: - Private Methods

private extension DeveloperTableViewCell {
    
    func setupInstagramTextView(instagram: Instagram) {
        let attributedString = NSMutableAttributedString(string: instagram.name,
                                                         attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.blue.cgColor])
        attributedString.addAttribute(.link, value: instagram.link, range: NSRange(location: 0, length: instagram.name.count))
        instagramTextView.attributedText = attributedString
        
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * instagramTextView.zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        instagramTextView.contentOffset.y = -positiveTopOffset
    }
    
}
