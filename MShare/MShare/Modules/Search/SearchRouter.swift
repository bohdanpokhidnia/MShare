//
//  SearchRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol SearchRouterProtocol {
    static func createModule() -> UIViewController
}

class SearchRouter: SearchRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view: SearchViewProtocol = SearchView()
        let presenter: SearchPresenterProtocol & SearchInteractorOutputProtocol = SearchPresenter()
        var interactor: SearchInteractorIntputProtocol = SearchInteractor()
        let router = SearchRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        return navigationController
    }
    
}
