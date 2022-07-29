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

class MainView: UITabBarController {
    
    enum TabItemIndex: Int {
        case appleMusic
        case spotify
        case link
        case search
        case settings
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
