//
//  FavoritesRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.10.2022.
//

import UIKit

protocol FavoritesRouterProtocol: ModuleRouterProtocol { }

final class FavoritesRouter: FavoritesRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view: FavoritesViewProtocol = FavoritesView()
        let presenter: FavoritesPresenterProtocol & FavoritesInteractorOutputProtocol = FavoritesPresenter()
        var interactor: FavoritesInteractorIntputProtocol = FavoritesInteractor()
        let router = FavoritesRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        return navigationController
    }
    
    func createModule() -> UIViewController {
        return FavoritesRouter.createModule()
    }
    
}
