//
//  MainRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

protocol MainRouterProtocol {
    func initMainModule() -> MainViewProtocol
}

final class MainRouter: Router, MainRouterProtocol {
    
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
        return view
    }
    
    override func createModule() -> UIViewController {
        return initMainModule().viewController
    }
    
}

// MARK: - Private Methods

private extension MainRouter {
    
    func buildTabModules() -> [UIViewController] {
        var views = [UIViewController]()
        
        for tabBarModule in MainView.TabItem.allCases {
            let router = tabBarModule.router(dependencyManager: dependencyManager)
            let view = router.createModule()
                .make {
                    $0.title = tabBarModule.title
                    $0.tabBarItem.image = tabBarModule.icon
                }
            
            views.append(view)
        }
        
        return views
    }
    
}
