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

class MainRouter: MainRouterProtocol {
    
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
        let chart = ChartRouter.createModule()
        chart.title = "Chart"
        chart.tabBarItem.image = UIImage(systemName: "chart.bar")
        
        let linkView = LinkRouter.createModule()
        linkView.title = "Link"
        linkView.tabBarItem.image = UIImage(systemName: "link")
        
        let searchView = SearchRouter.createModule()
        searchView.title = "Search"
        searchView.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let settingsView = SettingsRouter.createModule()
        settingsView.title = "Settings"
        settingsView.tabBarItem.image = UIImage(systemName: "gear")
        
        let views = [chart,
                     linkView,
                     searchView,
                     settingsView]
        return views
    }
    
   
}
