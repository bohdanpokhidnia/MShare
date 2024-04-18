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
    func selectTab(_ tabItem: MainEntity.TabItem)
}

final class MainView: UITabBarController {
    var presenter: MainPresenterProtocol?
    var viewController: UITabBarController { self }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarStyle()
    }
}

// MARK: - Private Methods

private extension MainView {
    func configureTabBarStyle() {
        let selectForegroundColor: UIColor = .appBlue
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        
        let selectedTitleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectForegroundColor,
        ]
        
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = selectForegroundColor
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedTitleTextAttributes
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

// MARK: - MainViewProtocol

extension MainView: MainViewProtocol {
    func setTabControllers(_ viewControllers: [UIViewController]) {
        setViewControllers(viewControllers, animated: false)
    }
    
    func selectTab(_ tabItem: MainEntity.TabItem) {
        selectedIndex = tabItem.rawValue
    }
}
