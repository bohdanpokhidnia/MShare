//
//  TableView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 30.07.2022.
//

import UIKit

class TableView: UITableView {
    // MARK: - Initializers
    
    init(style: UITableView.Style) {
        super.init(frame: .zero, style: style)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Set

extension TableView {
    @discardableResult
    func setRowHeight(_ height: CGFloat) -> Self {
        rowHeight = height
        return self
    }
    
    @discardableResult
    func setEstimatedRowHeight(_ height: CGFloat) -> Self {
        estimatedRowHeight = height
        return self
    }
    
    @discardableResult
    func enableScroll(_ scrollEnabled: Bool) -> Self {
        isScrollEnabled = scrollEnabled
        return self
    }
    
    @discardableResult
    func set(inset: UIEdgeInsets) -> Self {
        separatorInset = inset
        return self
    }
}
