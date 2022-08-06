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
    
    private(set) var tableView: TableView

    // MARK: - Initializers
    
    required init(tableViewStyle: UITableView.Style) {
        tableView = TableView(style: tableViewStyle)
        tableView.register(class: MediaTableViewCell.self)
        
        super.init()
    }
    
    @available(*, unavailable)
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    @discardableResult
    func set(inset: UIEdgeInsets) -> Self {
        tableView.set(inset: inset)
        return self
    }
    
    @discardableResult
    func set(separatorStyle: UITableViewCell.SeparatorStyle) -> Self {
        tableView.separatorStyle = separatorStyle
        return self
    }
    
}
