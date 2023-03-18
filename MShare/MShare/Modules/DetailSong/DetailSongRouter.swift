//
//  DetailSongRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit

protocol DetailSongRouterProtocol {
    func dismissModule(view: DetailSongViewProtocol?)
    func shareUrl(view: DetailSongViewProtocol?, urlString: String, completion: (() -> Void)?)
    func shareImage(view: DetailSongViewProtocol?, image: UIImage, savedImage: (() -> Void)?, completion: (() -> Void)?)
}
 
final class DetailSongRouter: Router, DetailSongRouterProtocol {
    
    let mediaResponse: MediaResponse
    let cover: UIImage
    
    init(dependencyManager: DependencyManagerProtocol, mediaResponse: MediaResponse, cover: UIImage) {
        self.mediaResponse = mediaResponse
        self.cover = cover
        
        super.init(dependencyManager: dependencyManager)
    }
    
    override func createModule() -> UIViewController {
        let view: DetailSongViewProtocol = DetailSongView()
        let presenter: DetailSongPresenterProtocol & DetailSongInteractorOutputProtocol = DetailSongPresenter()
        var interactor: DetailSongInteractorInputProtocol = DetailSongInteractor(
            databaseManager: dependencyManager.resolve(type: DatabaseManagerProtocol.self),
            apiClient: dependencyManager.resolve(type: ApiClient.self),
            mediaResponse: mediaResponse,
            cover: cover
        )
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = self
        interactor.presenter = presenter
        
        return view.viewController
    }
    
    func dismissModule(view: DetailSongViewProtocol?) {
        UINavigationBar.configure(style: .defaultBackground)
        
        view?.viewController.dismiss(animated: true)
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
    
}
