//
//  ServiceHeaderView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 08.08.2022.
//

import UIKit
import SnapKit

final class ServiceHeaderView: UITableViewHeaderFooterView, ViewLayoutableProtocol {
    
    // MARK: - UI
    
    private let titleLabel = UILabel()
        .text(alignment: .center)
    
    // MARK: - Initializers
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setup()
        setupSubviews()
        defineLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    func setup() {}
    
    func setupSubviews() {
        addSubview(titleLabel)
    }
    
    func defineLayout() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

// MARK: - Set

extension ServiceHeaderView {
    
    @discardableResult
    func set(_ title: String) -> Self {
        titleLabel.text(title)
        return self
    }
    
}
