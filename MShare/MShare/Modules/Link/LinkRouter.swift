//
//  LinkRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol LinkRouterProtocol {
    func presentSongDetailsScreen(
        from view: LinkViewProtocol?,
        mediaResponse: MediaResponse,
        cover: UIImage,
        completion: (() -> Void)?
    )
}

final class LinkRouter: Router {
    // MARK: - Override methods
    
    override func createModule() -> UIViewController {
        let apiClient = dependencyManager.resolve(type: ApiClient.self)
        
        let view: LinkViewProtocol = LinkView()
        let presenter: LinkPresenterProtocol & LinkInteractorOutputProtocol = LinkPresenter(view: view, router: self)
        let interactor: LinkInteractorIntputProtocol = LinkInteractor(presenter: presenter, apiClient: apiClient)
        
        view.presenter = presenter
        presenter.interactor = interactor
        
        let navigationController = AppNavigationController(rootViewController: view.viewController)
        navigationController.delegate = delegate
        return navigationController
    }
    
    // MARK: - Private
    
    private let delegate = AppNavigationControllerDelegate()
}

//MARK: - LinkRouterProtocol

extension LinkRouter: LinkRouterProtocol {
    func presentSongDetailsScreen(from view: LinkViewProtocol?, mediaResponse: MediaResponse, cover: UIImage, completion: (() -> Void)?) {
        let detailSongScreen = SongDetailsRouter(
            dependencyManager: dependencyManager,
            mediaResponse: mediaResponse,
            cover: cover
        )
        .createModule()
        
        view?.viewController.tabBarController?.setTabBar(hidden: true, animated: false) { [weak view] in
            view?.viewController.navigationController?.pushViewController(detailSongScreen, animated: true)
            completion?()
        }
    }
}
