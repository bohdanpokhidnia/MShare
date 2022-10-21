//
//  SettingsEntity.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

enum SettingsSection {
    typealias SettingItems = [SettingіItem]
    
    case favorites(SettingItems)
    case privacy(SettingItems)
    
    var items: SettingItems {
        switch self {
        case .favorites(let items):
            return items
            
        case .privacy(let items):
            return items
        }
    }
    
    var countOfSection: Int {
        return items.count
    }
    
    var title: String {
        switch self {
        case .favorites(_):
            return "Favorites"
            
        case .privacy(_):
            return "Information"
        }
    }
}

enum SettingіItem {
    case firstFavorites
    case aboutUs
    case privacyPolicyAndTerms
    
    var title: String {
        switch self {
        case .firstFavorites:
            return "First Favorites"
            
        case .aboutUs:
            return "About Us"
            
        case .privacyPolicyAndTerms:
            return "Privacy Policy & Terms"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .firstFavorites:
            return UIImage(named: "hearth")
            
        case .aboutUs:
            return UIImage(named: "group")
            
        case .privacyPolicyAndTerms:
            return UIImage(named: "privacyPolicy")
        }
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        switch self {
        case .firstFavorites:
            return .disclosureIndicator
            
        case .aboutUs:
            return .detailButton
            
        case .privacyPolicyAndTerms:
            return .detailDisclosureButton
        }
    }
}

struct SettingsItemState {
    let title: String
    let image: UIImage?
    let accesoryType: UITableViewCell.AccessoryType?
}

struct SettingsEntity {
    
}
