//
//  SearchRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol SearchRouterProtocol { }

final class SearchRouter: Router, SearchRouterProtocol {
    
    override func createModule() -> UIViewController {
        let view: SearchViewProtocol = SearchView()
        let presenter: SearchPresenterProtocol & SearchInteractorOutputProtocol = SearchPresenter()
        var interactor: SearchInteractorIntputProtocol = SearchInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = self
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        return navigationController
    }
    
}
