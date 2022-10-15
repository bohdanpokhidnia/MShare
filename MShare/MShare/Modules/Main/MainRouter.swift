//
//  MainRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

protocol MainRouterProtocol {
    static func createModule() -> MainViewProtocol
    static func createTabModules() -> [UIViewController]
}

final class MainRouter: MainRouterProtocol {
    
    static func createModule() -> MainViewProtocol {
        let view: MainViewProtocol = MainView()
        let presenter: MainPresenterProtocol & MainInteractorOutputProtocol = MainPresenter()
        var interactor: MainInteractorIntputProtocol = MainInteractor()
        let router = MainRouter()
        let tabViews = createTabModules()
        
        view.presenter = presenter
        view.setTabControllers(tabViews)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    static func createTabModules() -> [UIViewController] {
        var views = [UIViewController]()
        
        for tabBarModule in MainView.TabItemIndex.allCases {
            let view = tabBarModule.router.createModule()
                .make {
                    $0.title = tabBarModule.title
                    $0.tabBarItem.image = tabBarModule.icon
                }
            
            views.append(view)
        }
        
        return views
    }
    
   
}
