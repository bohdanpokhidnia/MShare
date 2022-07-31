//
//  ServiceTableViewCell.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 30.07.2022.
//

import UIKit

typealias ServiceItem = ServiceTableViewCell.State

final class ServiceTableViewCell: TableViewCell {
    
    static let iconImageContainerWidth: CGFloat = 80
    
    struct State {
        let title: String
        let imageURL: String
    }
    
    // MARK: - UI
    
    private lazy var contentStackView = makeStackView(
        axis: .horizontal
    )(
        iconImageContainer, titleLabel, View()
    )
    
    private let iconImageContainer = View()
    
    private let iconImageView = UIImageView()
        .make {
            $0.backgroundColor(color: .systemBlue)
        }
    
    private let titleLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
        
        iconImageContainer.addSubview(iconImageView)
        contentView.addSubview(contentStackView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        iconImageContainer.snp.makeConstraints {
            $0.width.equalTo(Self.iconImageContainerWidth)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview().offset(-10)
        }
    }
    
}

// MARK: - Set

extension ServiceTableViewCell {
    
    @discardableResult
    func set(state: State) -> Self {
        titleLabel.text = state.title
        return self
    }
    
}
