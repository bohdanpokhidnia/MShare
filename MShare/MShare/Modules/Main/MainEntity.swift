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
        case link
        case settings
        
        var title: String {
            switch self {
            case .favorites: "Favorites"
            case .link: "Link"
            case .settings: "Settings"
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .favorites: UIImage(systemName: "heart")
            case .link: UIImage(systemName: "link")
            case .settings: UIImage(systemName: "gear")
            }
        }
        
        func router(dependencyManager: DependencyManagerProtocol) -> Router {
            switch self {
            case .favorites: FavoritesRouter(dependencyManager: dependencyManager)
            case .link: LinkRouter(dependencyManager: dependencyManager)
            case .settings: SettingsRouter(dependencyManager: dependencyManager)
            }
        }
    }
}
