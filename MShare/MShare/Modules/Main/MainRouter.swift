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
    func makeRouter(for tabItem: MainEntity.TabItem) -> Router {
        switch tabItem {
        case .favorites:
            FavoritesRouter(dependencyManager: dependencyManager)
            
        case .link:
            LinkRouter(dependencyManager: dependencyManager)
            
        case .settings:
            SettingsRouter(
                appRouter: appRouter,
                dependencyManager: dependencyManager
            )
        }
    }
    
    func buildTabModules() -> [UIViewController] {
        var viewControllers: [UIViewController] = []
        
        for tabItem in MainEntity.TabItem.allCases {
            let router = makeRouter(for: tabItem)
            
            let view = router.createModule()
                .make {
                    $0.title = tabItem.title
                    $0.tabBarItem.image = tabItem.icon
                    $0.tabBarItem.selectedImage = tabItem.selectedIcon
                }
            
            viewControllers.append(view)
        }
        
        return viewControllers
    }
}
