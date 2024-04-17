//
//  DetailSongRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit

protocol SongDetailsRouterProtocol {
    func pop(view: DetailSongViewProtocol?)
    func shareUrl(
        view: DetailSongViewProtocol?,
        urlString: String,
        completion: (() -> Void)?
    )
    func shareImage(
        view: DetailSongViewProtocol?,
        image: UIImage,
        savedImage: (() -> Void)?,
        completion: (() -> Void)?
    )
    func pushMakeCover(view: DetailSongViewProtocol?)
}
 
final class SongDetailsRouter: Router {
    // MARK: - Initializers
    
    init(
        dependencyManager: DependencyManagerProtocol,
        mediaResponse: MediaResponse,
        cover: UIImage
    ) {
        self.mediaResponse = mediaResponse
        self.cover = cover
        
        super.init(dependencyManager: dependencyManager)
    }
    
    override func createModule() -> UIViewController {
        let databaseManager = dependencyManager.resolve(type: DatabaseManagerProtocol.self)
        let apiClient = dependencyManager.resolve(type: ApiClient.self)
        let factory = dependencyManager.resolve(type: FactoryProtocol.self)
        
        let view: DetailSongViewProtocol = SongDetailsView()
        let presenter: SongDetailsPresenterProtocol & DetailSongInteractorOutputProtocol = SongDetailsPresenter(view: view, router: self)
        let interactor: SongDetailsInteractorInputProtocol = SongDetailsInteractor(
            presenter: presenter,
            databaseManager: databaseManager,
            apiClient: apiClient,
            factory: factory,
            mediaResponse: mediaResponse,
            cover: cover
        )
        
        view.presenter = presenter
        presenter.interactor = interactor
        return view.viewController
    }
    
    // MARK: - Private
    
    private let mediaResponse: MediaResponse
    private let cover: UIImage
}

//MARK: - SongDetailsRouterProtocol

extension SongDetailsRouter: SongDetailsRouterProtocol {
    func pop(view: DetailSongViewProtocol?) {
        view?.viewController.navigationController?.popViewController(animated: true)
    }
    
    func shareUrl(view: DetailSongViewProtocol?, urlString: String, completion: (() -> Void)?) {
        let string = "Shared from MShare: \(urlString)"
        let shareItems = [string]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        DispatchQueue.main.async { [weak view] in
            view?.viewController.present(activityViewController, animated: true, completion: completion)
        }
    }
    
    func shareImage(view: DetailSongViewProtocol?, image: UIImage, savedImage: (() -> Void)?, completion: (() -> Void)?) {
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activityType, completed, array, error) in
            guard let activityType,
                  completed,
                  error == nil
            else { return }
            
            switch activityType {
            case .saveToCameraRoll:
                savedImage?()
                
            default:
                break
            }
        }
        
        view?.viewController.present(activityViewController, animated: true) {
            completion?()
        }
    }
    
    func pushMakeCover(view: DetailSongViewProtocol?) {
        let makeCover = MakeCoverRouter(
            dependencyManager: dependencyManager,
            mediaResponse: mediaResponse,
            cover: cover
        ).createModule()
        
        view?.viewController.navigationController?.pushViewController(makeCover, animated: true)
    }
}
