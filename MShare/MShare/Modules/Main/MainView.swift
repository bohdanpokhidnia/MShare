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
    func selectedTab(_ tabItemIndex: MainView.TabItemIndex)
}

final class MainView: UITabBarController {
    
    enum TabItemIndex: Int, CaseIterable {
//        case chart
        case favorites
        case link
//        case search
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
        
        var router: ModuleRouterProtocol {
            switch self {
//            case .chart:
//                return ChartRouter()
                
            case .favorites:
                return FavoritesRouter()
                
//            case .search:
//                return SearchRouter()
                
            case .link:
                return LinkRouter()
                
            case .settings:
                return SettingsRouter()
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
    
    func selectedTab(_ tabItemIndex: MainView.TabItemIndex) {
        selectedIndex = tabItemIndex.rawValue
    }
    
}
