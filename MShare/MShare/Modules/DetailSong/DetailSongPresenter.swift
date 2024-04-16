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
    func didTapPop()
    func copyCoverToBuffer(fromView view: ViewLayoutable)
    func shareCover(cover: UIImage)
    func saveToFavorite()
    func didTapShareMedia(for destinationService: String)
    func saveCover(cover: UIImage)
    func didTapMakeCover()
}

final class DetailSongPresenter: NSObject {
    weak var view: DetailSongViewProtocol?
    var interactor: DetailSongInteractorInputProtocol?
    var router: DetailSongRouterProtocol?
    
    // MARK: - Initializers
    
    init(view: DetailSongViewProtocol?, router: DetailSongRouterProtocol?) {
        self.view = view
        self.router = router
    }
    
    @objc
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            view?.showError("Error saving image: \(error.localizedDescription)")
        } else {
            view?.stopLoadingAnimation()
            view?.showSavedImage()
        }
    }
}

// MARK: - DetailSongPresenterProtocol

extension DetailSongPresenter: DetailSongPresenterProtocol {
    func viewDidLoad() {
        interactor?.requestMedia()
        interactor?.hasMediaInDatabase()
    }
    
    func didTapPop() {
        router?.pop(view: view)
    }
    
    func copyCoverToBuffer(fromView: ViewLayoutable) {
        let image = fromView.makeSnapShotImage(withBackground: false)
        interactor?.copyImageToBuffer(image)
        
        view?.showCopiedToast()
        
        view?.setCoverAnimation(animationState: .pressed) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.view?.setCoverAnimation(animationState: .unpressed, completion: nil)
            }
        }
    }
    
    func shareCover(cover: UIImage) {
        interactor?.requestAccessToGallery(cover)
    }
    
    func saveToFavorite() {
        interactor?.saveToDatabase()
    }
    
    func didTapShareMedia(for destinationService: String) {
        interactor?.requestShareMedia(for: destinationService)
    }
    
    func didTapMakeCover() {
        router?.pushMakeCover(view: view)
    }
}

// MARK: - DetailSongInteractorOutputProtocol

extension DetailSongPresenter: DetailSongInteractorOutputProtocol {
    func didLoadDetailMedia(_ detailMedia: DetailSongEntity) {
        var menuItems = [HorizontalActionMenuItem]()
        
        detailMedia.services.forEach { (service) in
            guard let action = HorizontalMenuAction(rawValue: service.type) else { return }
            menuItems.append(.init(horizontalMenuAction: action, available: service.isAvailable))
        }
        menuItems += [
            .init(horizontalMenuAction: .shareCover, available: true),
            .init(horizontalMenuAction: .saveCover, available: true),
            .init(horizontalMenuAction: .makeCover, available: true)
        ]
        
        view?.setupContent(withState: detailMedia, withHorizontalActionMenuItem: menuItems)
    }
    
    func didLoadShareMedia(_ shareMedia: ShareMediaResponse) {
        guard !shareMedia.isEmpty else {
            return
        }
        guard shareMedia.count == 1 else {
            view?.showAlertShareCount(for: shareMedia)
            return
        }
        guard let shareMediaItem = shareMedia.items.first else {
            return
        }
        
        router?.shareUrl(view: view, urlString: shareMediaItem.songUrl) { [weak view] in
            view?.stopShareLoading()
        }
    }
    
    func hasMediaInDatabase(_ isSaved: Bool) {
        view?.setFavoriteStatus(isSaved)
    }
    
    func didCatchError(_ error: NetworkError) {
        view?.showError(error.localizedDescription)
    }
    
    func didRequestedAccessToGallery(_ image: UIImage) {
        router?.shareImage(
            view: view,
            image: image,
            savedImage: view?.showSavedImage,
            completion: { [weak view] in
                view?.stopLoadingAnimation()
            }
        )
    }
    
    func saveCover(cover: UIImage) {
        UIImageWriteToSavedPhotosAlbum(cover, self, #selector(image), nil)
    }
    
    func didSaveToDatabase() {
        AlertKit.shortToast(
            title: "Saved to Favorites",
            icon: .done,
            position: .center,
            haptic: .success
        )
    }
    
    func didDeleteFromDatabase() {
        AlertKit.shortToast(
            title: "Removed from Favorites",
            icon: .done,
            position: .center,
            haptic: .success
        )
    }
}
