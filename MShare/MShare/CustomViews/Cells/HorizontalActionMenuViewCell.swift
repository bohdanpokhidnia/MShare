//
//  HorizontalActionMenuViewCell.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 11.08.2022.
//

import UIKit
import SnapKit

final class HorizontalActionMenuViewCell: CollectionViewCell {
    
    struct State {
        let image: UIImage?
        let title: String
    }
    
    // MARK: - UI
    
    private let containerView = View()
    
    private let actionImageContrainerView = View()
    
    private let actionImageView = UIImageView()
        .setContentMode(.scaleAspectFit)
        .backgroundColor(color: .gray)
    
    private let actionTitleLabel = UILabel()
        .text(alignment: .center)
        .text(font: UIFont.systemFont(ofSize: 15, weight: .heavy))
        .textColor(.white)
        .set(numberOfLines: 0)
        .adjustsFontSizeToFitWidth(true)
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        setCornerRadius(cellCornerRadius)
        maskToBounds(true)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        actionImageContrainerView.addSubview(actionImageView)
        containerView.addSubviews(actionImageContrainerView, actionTitleLabel)
        contentView.addSubview(containerView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        actionImageContrainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        actionImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        actionTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(UIEdgeInsets(horizontal: 5))
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: - Private
    
    private let cellCornerRadius: CGFloat = 12
    
}

extension HorizontalActionMenuViewCell {
    
    @discardableResult
    func set(state: State) -> Self {
        actionImageView.setImage(state.image)
        actionTitleLabel.text(state.title)
        return self
    }
    
}
