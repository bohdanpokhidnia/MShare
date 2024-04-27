//
//  SettingsEntity.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

enum SettingsItem {
    case firstFavorites
    case accessToGallery
    case aboutUs
    case privacyPolicyAndTerms
    case support
    case versionApp(String)
}

struct SettingsSection {
    let title: String
    let items: [SettingsItem]
}

struct SettingsEntity {
    let title: String
    let image: UIImage?
    let accessoryType: UITableViewCell.AccessoryType?
}
