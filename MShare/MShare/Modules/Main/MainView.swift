//
//  MainView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    var presenter: MainPresenterProtocol? { get set }
    var viewController: UITabBarController { get }
    
    func setTabControllers(_ viewControllers: [UIViewController])
    func selectedTab(_ tabItem: MainView.TabItem)
}

final class MainView: UITabBarController {
    
    enum TabItem: Int, CaseIterable {
        case favorites
//        case chart
//        case search
        case link
        case settings
        
        var title: String {
            switch self {
            case .favorites:
                return "Favorites"
                
//            case .chart:
//                return "Chart"
                
//            case .search:
//                return "Search"
            
            case .link:
                return "Link"
                
            case .settings:
                return "Settings"
            }
        }
        
        var icon: UIImage? {
            switch self {
//            case .search:
//                return nil
                
//            case .chart:
//                return UIImage(systemName: "chart.bar")
                
            case .favorites:
                return UIImage(systemName: "heart")
                
            case .link:
                return UIImage(systemName: "link")
                
            case .settings:
                return UIImage(systemName: "gear")
            }
        }
        
        func router(dependencyManager: DependencyManagerProtocol) -> Router {
            switch self {
            case .favorites:
                return FavoritesRouter(dependencyManager: dependencyManager)
                
            case .link:
                return LinkRouter(dependencyManager: dependencyManager)
                
            case .settings:
                return SettingsRouter(dependencyManager: dependencyManager)
            }
        }
    }
    
    var presenter: MainPresenterProtocol?
    
    var viewController: UITabBarController {
        return self
    }
    
}

// MARK: - MainViewProtocol

extension MainView: MainViewProtocol {
    
    func setTabControllers(_ viewControllers: [UIViewController]) {
        setViewControllers(viewControllers, animated: false)
    }
    
    func selectedTab(_ tabItem: MainView.TabItem) {
        selectedIndex = tabItem.rawValue
    }
    
}
