//
//  MainRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

protocol MainRouterProtocol {
    func initMainModule() -> MainViewProtocol
    func select(tab: MainEntity.TabItem)
}

final class MainRouter: Router {
    // MARK: - Override methods
    
    override func createModule() -> UIViewController {
        return initMainModule().viewController
    }
    
    // MARK: - Private
    
    private var tabBarController: UITabBarController?
}

//MARK: - MainRouterProtocol

extension MainRouter: MainRouterProtocol {
    func initMainModule() -> MainViewProtocol {
        let view: MainViewProtocol = MainView()
        let presenter: MainPresenterProtocol & MainInteractorOutputProtocol = MainPresenter()
        var interactor: MainInteractorIntputProtocol = MainInteractor()
        let tabViews = buildTabModules()
        
        view.presenter = presenter
        view.setTabControllers(tabViews)
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = self
        
        interactor.presenter = presenter
        tabBarController = view.viewController
        return view
    }
    
    func select(tab: MainEntity.TabItem) {
        tabBarController?.selectedIndex = tab.rawValue
    }
}

// MARK: - Private Methods

private extension MainRouter {
    func buildTabModules() -> [UIViewController] {
        var viewControllers: [UIViewController] = []
        
        for tabBarModule in MainEntity.TabItem.allCases {
            let router = tabBarModule.router(dependencyManager: dependencyManager)
            let view = router.createModule()
                .make {
                    $0.title = tabBarModule.title
                    $0.tabBarItem.image = tabBarModule.icon
                }
            
            viewControllers.append(view)
        }
        
        return viewControllers
    }
}
