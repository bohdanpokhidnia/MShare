//
//  FavoritesRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.10.2022.
//

import UIKit

protocol FavoritesRouterProtocol {
    func shareUrl(view: FavoritesViewProtocol?, urlString: String)
    func presentDetailSongScreen(fromView view: FavoritesViewProtocol?, mediaResponse: MediaResponse, cover: UIImage)
}

final class FavoritesRouter: Router {
    
    // MARK: - Override methods
    
    override func createModule() -> UIViewController {
        let userManager = dependencyManager.resolve(type: UserManagerProtocol.self)
        let databaseManager = dependencyManager.resolve(type: DatabaseManagerProtocol.self)
        
        let view: FavoritesViewProtocol = FavoritesView()
        let presenter: FavoritesPresenterProtocol & FavoritesInteractorOutputProtocol = FavoritesPresenter()
        var interactor: FavoritesInteractorIntputProtocol = FavoritesInteractor(
            userManager: userManager,
            databaseManager: databaseManager
        )

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = self
        interactor.presenter = presenter
        
        let navigationController = AppNavigationController(rootViewController: view.viewController)
        navigationController.delegate = delegate
        navigationController.isRecognizerEnabled = false
        return navigationController
    }
    
    // MARK: - Private
    
    private let delegate = AppNavigationControllerDelegate()
    
}

//MARK: - FavoritesRouterProtocol

extension FavoritesRouter: FavoritesRouterProtocol {
    
    func shareUrl(view: FavoritesViewProtocol?, urlString: String) {
        let shareItems = [URL(string: urlString)]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        view?.viewController.present(activityViewController, animated: true)
    }
    
    func presentDetailSongScreen(fromView view: FavoritesViewProtocol?, mediaResponse: MediaResponse, cover: UIImage) {
        let detailSongScreen = DetailSongRouter(dependencyManager: dependencyManager, mediaResponse: mediaResponse, cover: cover)
            .createModule()
        
        view?.viewController.navigationController?.pushViewController(detailSongScreen, animated: true)
    }
    
}
