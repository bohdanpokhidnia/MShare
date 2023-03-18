//
//  FavoritesRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.10.2022.
//

import UIKit

protocol FavoritesRouterProtocol {
    func shareUrl(view: FavoritesViewProtocol?, urlString: String)
    func presentDetailSongScreen(fromView view: FavoritesViewProtocol?, mediaModel: MediaModel)
}

final class FavoritesRouter: Router, FavoritesRouterProtocol {
    
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
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        return navigationController
    }
    
    func shareUrl(view: FavoritesViewProtocol?, urlString: String) {
        let shareItems = [URL(string: urlString)]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        view?.viewController.present(activityViewController, animated: true)
    }
    
    func presentDetailSongScreen(fromView view: FavoritesViewProtocol?, mediaModel: MediaModel) {
        guard let coverImage = UIImage(data: mediaModel.coverData),
              let mediaType = MediaType(rawValue: mediaModel.mediaType)
        else { return }
        
        var song: Song?
        var album: Album?
        let services: [MediaService] = mediaModel.services.map { (service) in
            .init(name: service.name, type: service.type, isAvailable: service.isAvailable)
        }
        
        switch mediaType {
        case .song:
            song = Song(
                songSourceId: mediaModel.sourceId,
                songUrl: mediaModel.url,
                songName: mediaModel.name,
                artistName: mediaModel.artistName,
                albumName: mediaModel.albumName,
                coverImageUrl: mediaModel.coverImageUrl,
                serviceType: mediaModel.serviceType
            )
            
        case .album:
            album = Album(
                albumSourceId: mediaModel.sourceId,
                albumUrl: mediaModel.url,
                albumName: mediaModel.albumName,
                artistName: mediaModel.artistName,
                coverImageUrl: mediaModel.coverImageUrl,
                serviceType: mediaModel.serviceType
            )
        }
        
        let mediaResponse = MediaResponse(
            mediaType: mediaType,
            song: song,
            album: album,
            services: services
        )
        let detailSongScreen = DetailSongRouter(dependencyManager: dependencyManager, mediaResponse: mediaResponse, cover: coverImage).createModule()
        let navigationController = UINavigationController(rootViewController: detailSongScreen)
            .make { $0.modalPresentationStyle = .fullScreen }
        
        view?.viewController.present(navigationController, animated: true)
    }
    
}
