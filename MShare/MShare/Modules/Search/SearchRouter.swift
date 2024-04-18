//
//  LinkRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit
import TipKit

protocol SearchRouterProtocol {
    func presentSongDetailsScreen(
        from view: SearchViewProtocol?,
        mediaResponse: MediaResponse,
        cover: UIImage,
        completion: (() -> Void)?
    )
    
    func present(from view: SearchViewProtocol?, viewController: UIViewController)
    func dismissPresentedPopover(for view: SearchViewProtocol?)
}

final class SearchRouter: Router {
    // MARK: - Override methods
    
    override func createModule() -> UIViewController {
        let apiClient = dependencyManager.resolve(type: ApiClient.self)
        let userManager = dependencyManager.resolve(type: UserManagerProtocol.self)
        
        let view: SearchViewProtocol = SearchView()
        let presenter: SearchPresenterProtocol & SearchInteractorOutputProtocol = SearchPresenter(view: view, router: self)
        let interactor: SearchInteractorIntputProtocol = SearchInteractor(
            presenter: presenter,
            apiClient: apiClient,
            userManager: userManager
        )
        
        view.presenter = presenter
        presenter.interactor = interactor
        
        let navigationController = AppNavigationController(rootViewController: view.viewController)
        navigationController.delegate = delegate
        return navigationController
    }
    
    // MARK: - Private
    
    private let delegate = AppNavigationControllerDelegate()
}

//MARK: - SearchRouterProtocol

extension SearchRouter: SearchRouterProtocol {
    func presentSongDetailsScreen(from view: SearchViewProtocol?, mediaResponse: MediaResponse, cover: UIImage, completion: (() -> Void)?) {
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
    
    func present(from view: SearchViewProtocol?, viewController: UIViewController) {
        view?.viewController.present(viewController, animated: true)
    }
    
    func dismissPresentedView(for view: SearchViewProtocol?) {
        view?.viewController.presentedViewController?.dismiss(animated: true)
    }
    
    func dismissPresentedPopover(for view: SearchViewProtocol?) {
        guard #available(iOS 17.0, *) else {
            return
        }
        guard let presentedViewController = view?.viewController.presentedViewController else {
            return
        }
        guard presentedViewController is TipUIPopoverViewController else {
            return
        }
        
        presentedViewController.dismiss(animated: true)
    }
}
