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
    case access(SettingItems)
    
    var items: SettingItems {
        switch self {
        case .favorites(let items):
            return items
            
        case .privacy(let items):
            return items
            
        case .access(let items):
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
            
        case .access(_):
            return "Access"
        }
    }
}

enum SettingіItem {
    case firstFavorites
    case accessToGallery
    case aboutUs
    case privacyPolicyAndTerms
    case versionApp(String)
    
    var title: String {
        switch self {
        case .firstFavorites:
            return "First Favorites"
            
        case .accessToGallery:
            return "Access to gallery"
            
        case .aboutUs:
            return "About Us"
            
        case .privacyPolicyAndTerms:
            return "Privacy Policy & Terms"
            
        case .versionApp(let version):
            return "Version: \(version)"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .firstFavorites:
            return UIImage(named: "hearth")
            
        case .accessToGallery:
            return UIImage(systemName: "photo.on.rectangle.angled")
            
        case .aboutUs:
            return UIImage(named: "group")
            
        case .privacyPolicyAndTerms:
            return UIImage(named: "privacyPolicy")
            
        case .versionApp(_):
            return UIImage(named: "AppIcon")
        }
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        switch self {
        case .firstFavorites:
            return .disclosureIndicator
            
        case .accessToGallery:
            return .disclosureIndicator
            
        case .aboutUs:
            return .disclosureIndicator
            
        case .privacyPolicyAndTerms:
            return .disclosureIndicator
            
        case .versionApp(_):
            return .none
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
