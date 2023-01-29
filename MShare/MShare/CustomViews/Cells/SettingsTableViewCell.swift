//
//  SettingsTableViewCell.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 21.10.2022.
//

import UIKit

final class SettingsTableViewCell: TableViewCell {
    
}

// MARK: - Set

extension SettingsTableViewCell {
    
    @discardableResult
    func set(state: SettingsItemState) -> Self {
        if let accecoryView = state.accesoryType {
            accessoryType = accecoryView
        }
        
        if #available(iOS 14.0, *) {
            var cellConfig: UIListContentConfiguration = defaultContentConfiguration()
            cellConfig.text = state.title
            cellConfig.image = state.image
            cellConfig.imageProperties.cornerRadius = 4
            
            contentConfiguration = cellConfig
        } else {
            textLabel?.text = state.title
            imageView?.image = state.image
        }
        
        return self
    }
    
}
