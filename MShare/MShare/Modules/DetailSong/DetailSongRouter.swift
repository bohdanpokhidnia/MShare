//
//  DetailSongRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit

protocol DetailSongRouterProtocol {
    static func createModule(mediaResponse: MediaResponse, cover: UIImage) -> UIViewController
    
    func dismissModule(view: DetailSongViewProtocol?)
    func shareImage(view: DetailSongViewProtocol?, image: UIImage, completion: (() -> Void)?)
}
 
final class DetailSongRouter: DetailSongRouterProtocol {
    
    static func createModule(mediaResponse: MediaResponse, cover: UIImage) -> UIViewController {
        let view: DetailSongViewProtocol = DetailSongView()
        let presenter: DetailSongPresenterProtocol & DetailSongInteractorOutputProtocol = DetailSongPresenter()
        var interactor: DetailSongInteractorInputProtocol = DetailSongInteractor(mediaResponse: mediaResponse, cover: cover)
        let router = DetailSongRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view.viewController
    }
    
    func dismissModule(view: DetailSongViewProtocol?) {
        UINavigationBar.configure(style: .defaultBackground)
        
        view?.viewController.dismiss(animated: true)
    }
    
    func shareImage(view: DetailSongViewProtocol?, image: UIImage, completion: (() -> Void)?) {
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            .make { $0.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.saveToCameraRoll] }
        
        view?.viewController.present(activityViewController, animated: true) {
            completion?()
        }
    }
    
}
