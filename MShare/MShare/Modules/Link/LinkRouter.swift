//
//  LinkRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol LinkRouterProtocol: ModuleRouterProtocol {
    func presentDetailSongScreen(from view: LinkViewProtocol?, mediaResponse: MediaResponse, cover: UIImage, completion: (() -> Void)?)
}

class LinkRouter: LinkRouterProtocol {
    
    static func createModule() -> UIViewController {
        let presenter: LinkPresenterProtocol & LinkInteractorOutputProtocol = LinkPresenter()
        let view: LinkViewProtocol = LinkView(presenter: presenter)
        var interactor: LinkInteractorIntputProtocol = LinkInteractor()
        let router = LinkRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        return navigationController
    }
    
    func createModule() -> UIViewController {
        return LinkRouter.createModule()
    }
    
    func presentDetailSongScreen(from view: LinkViewProtocol?, mediaResponse: MediaResponse, cover: UIImage, completion: (() -> Void)?) {
        let detailSongScreen = DetailSongRouter.createModule(mediaResponse: mediaResponse, cover: cover)
        let navigationController = UINavigationController(rootViewController: detailSongScreen)
        navigationController.modalPresentationStyle = .fullScreen
        
        view?.viewController.present(navigationController, animated: true, completion: completion)
    }
    
}
