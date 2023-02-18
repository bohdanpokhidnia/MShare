//
//  TableViewCell.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 30.07.2022.
//

import UIKit

class TableViewCell: UITableViewCell, ViewLayoutableProtocol, Themeable {
    
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
        themeProvider.register(observer: self)
    }
    
    func setupSubviews() {
        
    }
    
    func defineLayout() {
        
    }
    
    func apply(theme: AppTheme) {
        
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

//MARK: - UIComponentsLibrary

extension TableViewCell {
    
    @discardableResult
    func set(component: UIComponentsLibrary.Component) -> Self {
        backgroundColor(color: component.color)
        return self
    }
    
}
