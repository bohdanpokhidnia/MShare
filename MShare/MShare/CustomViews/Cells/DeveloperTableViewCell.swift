//
//  DeveloperTableViewCell.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 23.10.2022.
//

import UIKit

final class DeveloperTableViewCell: TableViewCell {
    
    struct State {
        let name: String
        let role: String
        let avatar: UIImage?
    }

    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()

        accessoryType = .disclosureIndicator
    }
    
}

// MARK: - Set

extension DeveloperTableViewCell {
    
    @discardableResult
    func set(state: State) -> Self {
        if #available(iOS 14.0, *) {
            var cellConfig = defaultContentConfiguration()
            
            cellConfig.image = state.avatar
            cellConfig.imageProperties.cornerRadius = 24
            cellConfig.text = state.name
            cellConfig.secondaryText = state.role
            
            contentConfiguration = cellConfig
        } else {
            imageView?.image = state.avatar
            textLabel?.text = state.name
            detailTextLabel?.text = state.role
        }
        
        return self
    }
    
}
