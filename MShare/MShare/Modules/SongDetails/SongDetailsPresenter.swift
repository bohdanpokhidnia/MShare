//
//  SongDetailsPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit
import Photos

protocol SongDetailsPresenterProtocol: AnyObject {
    var view: SongDetailsViewProtocol? { get set }
    var interactor: SongDetailsInteractorInputProtocol? { get set }
    var router: SongDetailsRouterProtocol? { get set }
    
    func viewDidLoad()
    func didTapPop()
    func copyCoverToBuffer(fromView view: ViewLayoutable)
    func shareCover(cover: UIImage)
    func saveToFavorite()
    func didTapShareMedia(for destinationService: String)
    func saveCover(cover: UIImage)
    func didTapMakeCover()
}

final class SongDetailsPresenter: BasePresenter {
    weak var view: SongDetailsViewProtocol?
    var interactor: SongDetailsInteractorInputProtocol?
    var router: SongDetailsRouterProtocol?
    
    // MARK: - Initializers
    
    init(view: SongDetailsViewProtocol?, router: SongDetailsRouterProtocol?) {
        self.view = view
        self.router = router
        
        super.init(baseView: view)
    }
    
    // MARK: - Private Methods
    
    override func handleNetworkError(error: BaseError) {
        view?.stopLoadingAnimation()
        
        AlertKit.shortToast(
            title: error.localizedDescription,
            icon: .error,
            position: .center,
            haptic: .error
        )
    }
    
    // MARK: - Private
    
    private lazy var shortToastY: CGFloat = view?.shortToastPositionY ?? .zero
}

// MARK: - DetailSongPresenterProtocol

extension SongDetailsPresenter: SongDetailsPresenterProtocol {
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
        
        AlertKit.shortToast(
            title: "Cover copied",
            icon: .custom(UIImage(systemName: "doc.on.doc.fill")!),
            position: .top,
            haptic: .success
        )
        
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

// MARK: - Private Methods

private extension SongDetailsPresenter {
    func showSavedImage() {
        AlertKit.shortToast(
            title: "Image saved successfully",
            icon: .custom(UIImage(systemName: "photo.on.rectangle.angled")!),
            position: .top,
            haptic: .success
        )
    }
}

// MARK: - DetailSongInteractorOutputProtocol

extension SongDetailsPresenter: DetailSongInteractorOutputProtocol {
    func didLoadDetailMedia(_ detailMedia: SongDetailsEntity) {
        var menuItems = [HorizontalActionMenuItem]()
        
        detailMedia.services.forEach { (service) in
            guard let action = HorizontalMenuAction(rawValue: service.type) else { return }
            menuItems.append(.init(horizontalMenuAction: action, available: service.isAvailable))
        }
        
        menuItems += [
            .init(horizontalMenuAction: .shareCover, available: true),
            .init(horizontalMenuAction: .saveCover, available: true),
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
        view?.stopLoadingAnimation()
    }
    
    func didRequestedAccessToGallery(_ image: UIImage) {
        router?.shareImage(
            view: view,
            image: image,
            savedImage: { [weak self] in
                DispatchQueue.main.async {
                    self?.showSavedImage()
                }
            },
            completion: { [weak view] in
                view?.stopLoadingAnimation()
            }
        )
    }
    
    func saveCover(cover: UIImage) {
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: cover)
            }
            
            view?.stopLoadingAnimation()
            showSavedImage()
        } catch {
            view?.stopLoadingAnimation()
            view?.showError("Error saving image: \(error.localizedDescription)")
        }
    }
    
    func didSaveToDatabase() {
        AlertKit.shortToast(
            title: "Saved to Favorites",
            icon: .heart,
            position: .custom(y: shortToastY),
            haptic: .success
        )
    }
    
    func didDeleteFromDatabase() {
        AlertKit.shortToast(
            title: "Removed from Favorites",
            icon: .done,
            position: .custom(y: shortToastY),
            haptic: .success
        )
    }
}
