//
//  DetailSongPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit

protocol DetailSongPresenterProtocol: AnyObject {
    var view: DetailSongViewProtocol? { get set }
    var interactor: DetailSongInteractorInputProtocol? { get set }
    var router: DetailSongRouterProtocol? { get set }
    
    func viewDidLoad()
    func dismissAction()
    func copyCoverToBuffer(fromView view: View)
    func shareCover(cover: UIImage, completion: (() -> Void)?)
    func saveToFavorite()
    func didTapShareMedia(for destinationService: String)
}

final class DetailSongPresenter {
    var view: DetailSongViewProtocol?
    var interactor: DetailSongInteractorInputProtocol?
    var router: DetailSongRouterProtocol?
}

// MARK: - DetailSongPresenterProtocol

extension DetailSongPresenter: DetailSongPresenterProtocol {
    
    func viewDidLoad() {
        interactor?.requestMedia()
        interactor?.hasMediaInDatabase()
    }
    
    func dismissAction() {
        router?.dismissModule(view: view)
    }
    
    func copyCoverToBuffer(fromView: View) {
        let image = fromView.makeSnapShotImage(withBackground: false)
        interactor?.copyImageToBuffer(image)
        
        view?.showCopiedToast()
        
        view?.setCoverAnimation(animationState: .pressed) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.view?.setCoverAnimation(animationState: .unpressed, completion: nil)
            }
        }
    }
    
    func shareCover(cover: UIImage, completion: (() -> Void)?) {
        interactor?.requestAccessToGallery(cover, completion: completion)
    }
    
    func saveToFavorite() {
        interactor?.saveToDatabase()
    }
    
    func didTapShareMedia(for destinationService: String) {
        interactor?.requestShareMedia(for: destinationService)
    }
    
}

// MARK: - DetailSongInteractorOutputProtocol

extension DetailSongPresenter: DetailSongInteractorOutputProtocol {
    
    func didLoadDetailMedia(_ detailMedia: DetailSongEntity) {
        var menuItems = [HorizontalActionMenuItem]()
        
        detailMedia.services.forEach {
            guard let action = HorizontalMenuAction(rawValue: $0.type) else { return }
            menuItems.append(.init(horizontalMenuAction: action, available: $0.isAvailable))
        }
        menuItems.append(.init(horizontalMenuAction: .shareCover, available: true))
        
        view?.setupContent(withState: detailMedia, withHorizontalActionMenuItem: menuItems)
    }
    
    func didLoadShareMedia(_ shareMedia: ShareMediaResponse) {
        guard !shareMedia.isEmpty else { return }
        
        guard shareMedia.count == 1 else {
            view?.showAlertShareCount(for: shareMedia)
            return
        }
        
        guard let shareMediaItem = shareMedia.items.first else { return }
        
        router?.shareUrl(view: view, urlString: shareMediaItem.songUrl) { [weak view] in
            view?.stopShareLoading()
        }
    }
    
    func hasMediaInDatabase(_ isSaved: Bool) {
        view?.setFavoriteStatus(isSaved)
    }
    
    func didCatchError(_ error: NetworkError) {
        DispatchQueue.main.async { [weak view] in
            view?.showError(error.localizedDescription)
        }
    }
    
    func didRequestedAccessToGallery(_ image: UIImage, completion: (() -> Void)?) {
        router?.shareImage(view: view, image: image, completion: completion)
    }
    
}
