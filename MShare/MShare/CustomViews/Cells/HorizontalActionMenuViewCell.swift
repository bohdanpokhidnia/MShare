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
    
    private let actionImageView = UIImageView()
        .setContentMode(.scaleAspectFit)
        .setCornerRadius(18)
        .maskToBounds(true)
        .borderWidth(1, color: .black)
        .backgroundColor(color: .white)
    
    private let actionTitleLabel = UILabel()
        .text(alignment: .center)
        .textColor(.black)
        .set(numberOfLines: 1)
        .adjustsFontSizeToFitWidth(true)
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
        
        containerView.addSubviews(actionImageView, actionTitleLabel)
        contentView.addSubview(containerView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        actionImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }

        actionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(actionImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
}

extension HorizontalActionMenuViewCell {
    
    @discardableResult
    func set(state: State) -> Self {
        actionImageView.setImage(state.image)
        actionTitleLabel.text(state.title)
        return self
    }
    
}
