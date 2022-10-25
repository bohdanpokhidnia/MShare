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
    
    private lazy var contentStackView = makeStackView(
        axis: .vertical,
        spacing: 10
    )(
        nameStackView,
        instagramStackView
    )
    
    private lazy var nameStackView = makeStackView(
        axis: .horizontal,
        spacing: 60
    )(
        avatarImageView, nameLabel, View()
    )
    
    private lazy var instagramStackView = makeStackView(
        axis: .horizontal,
        spacing: 14
    )(
        instagramLabel, instagramTextView
    )
    
    private let avatarImageView = UIImageView()
        .setCornerRadius(20)
        .maskToBounds(true)
        .backgroundColor(color: .red)
    
    private let nameLabel = UILabel()
    
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
        
        contentView.addSubview(contentStackView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(all: 16))
        }
        
        avatarImageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
    }
    
}

// MARK: - Set

extension DeveloperTableViewCell {
    
    @discardableResult
    func set(state: State) -> Self {
        avatarImageView.image = state.avatar
        nameLabel.text(state.name)
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
