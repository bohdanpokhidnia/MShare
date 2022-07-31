//
//  TableView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 30.07.2022.
//

import UIKit

class TableView: UITableView {
    
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
    func set(_ inset: UIEdgeInsets) -> Self {
        separatorInset = inset
        return self
    }
    
}
