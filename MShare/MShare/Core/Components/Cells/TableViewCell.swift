//
//  TableViewCell.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 30.07.2022.
//

import UIKit

class TableViewCell: UITableViewCell, ViewLayoutableProtocol {
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupSubviews()
        defineLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLayoutableProtocol
    
    func setup() {
        
    }
    
    func setupSubviews() {
        
    }
    
    func defineLayout() {
        
    }
    
}

// MARK: - Set

extension TableViewCell {
    
    @discardableResult
    func accessoryType(_ cellAccessoryType: UITableViewCell.AccessoryType) -> Self {
        accessoryType = cellAccessoryType
        return self
    }
    
}
