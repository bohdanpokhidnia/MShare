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
