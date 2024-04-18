//
//  MainEntity.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

struct MainEntity {
    enum TabItem: Int, CaseIterable {
        case favorites
        case search
        case settings
        
        var title: String {
            switch self {
            case .favorites: "Favorites"
            case .search: "Search"
            case .settings: "Settings"
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .favorites: UIImage(systemName: "heart")
            case .search: UIImage(systemName: "magnifyingglass")
            case .settings: UIImage(systemName: "gear")
            }
        }
        
        var selectedIcon: UIImage? {
            switch self {
            case .favorites: UIImage(systemName: "heart.fill")
            case .search: icon
            case .settings: icon
            }
        }
    }
}
