//
//  LinkRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol LinkRouterProtocol {
    static func createModule() -> UIViewController
}

class LinkRouter: LinkRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view: LinkViewProtocol = LinkView()
        let presenter: LinkPresenterProtocol & LinkInteractorOutputProtocol = LinkPresenter()
        var interactor: LinkInteractorIntputProtocol = LinkInteractor()
        let router = LinkRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        return navigationController
    }
    
}
