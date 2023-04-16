//
//  LinkRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol LinkRouterProtocol {
    func presentDetailSongScreen(from view: LinkViewProtocol?, mediaResponse: MediaResponse, cover: UIImage, completion: (() -> Void)?)
}

final class LinkRouter: Router, LinkRouterProtocol {
    
    override func createModule() -> UIViewController {
        let presenter: LinkPresenterProtocol & LinkInteractorOutputProtocol = LinkPresenter()
        let view: LinkViewProtocol = LinkView(presenter: presenter)
        var interactor: LinkInteractorIntputProtocol = LinkInteractor(apiClient: dependencyManager.resolve(type: ApiClient.self))
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = self
        interactor.presenter = presenter
        
        let navigationController = AppNavigationController(rootViewController: view.viewController)
        return navigationController
    }
    
    func presentDetailSongScreen(from view: LinkViewProtocol?, mediaResponse: MediaResponse, cover: UIImage, completion: (() -> Void)?) {
        let detailSongScreen = DetailSongRouter(dependencyManager: dependencyManager, mediaResponse: mediaResponse, cover: cover)
            .createModule()
        let navigation = AppNavigationController(rootViewController: detailSongScreen).make {
            $0.modalPresentationStyle = .fullScreen
        }
        
        view?.viewController.present(navigation, animated: true, completion: completion)
    }
    
}
