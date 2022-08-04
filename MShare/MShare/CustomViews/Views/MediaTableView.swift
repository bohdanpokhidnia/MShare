//
//  MediaTableView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 04.08.2022.
//

import UIKit
import SnapKit

final class MediaTableView: View {
    
    // MARK: - UI
    
    private(set) lazy var tableView = TableView()
        .register(class: MediaTableViewCell.self)
        .set(inset: .init(aLeft: MediaTableViewCell.iconImageContainerWidth))
    
    
    // MARK: - Lifecycle
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(tableView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

// MARK: - Set

extension MediaTableView {
    
    @discardableResult
    func set(rowHeight: CGFloat) -> Self {
        tableView.setRowHeight(rowHeight)
        return self
    }
    
    @discardableResult
    func enableScroll(_ isEnabled: Bool) -> Self {
        tableView.enableScroll(isEnabled)
        return self
    }
    
}
