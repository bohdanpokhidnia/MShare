//
//  DetailSongView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit

protocol DetailSongViewProtocol: AnyObject {
    var presenter: DetailSongPresenterProtocol? { get set }
    var viewController: UIViewController { get }
    
    func setupContent(withState state: DetailSongEntity, withHorizontalActionMenuItem horizontalActionMenuItem: [HorizontalActionMenuItem])
    func setFavoriteStatus(_ isSaved: Bool)
    func setCoverAnimation(animationState: CoverViewAnimation, completion: (() -> Void)?)
    func showCopiedToast()
    func showUnavailableToast()
    func stopShareLoading()
    func showError(_ error: String)
    func showAlertShareCount(for shareMedia: ShareMediaResponse)
    func showSavedImage()
    func stopLoadingAnimation()
}

final class DetailSongView: ViewController<DetailSongContentView> {
    
    var presenter: DetailSongPresenterProtocol?
    
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupViews()
        setupActionsHandler()
        
        presenter?.viewDidLoad()
    }

}

// MARK: - Setup

private extension DetailSongView {
    
    func setupNavigationBar() {
        title = "Share"
        UINavigationBar.configure(style: .transcelent)
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapDismissBarButton))
    }
    
    func setupViews() {
        contentView.horizontalActionMenuView.delegare = self
    }
    
    func setupActionsHandler() {
        contentView.coverView.whenTap = { [unowned self] in
            presenter?.copyCoverToBuffer(fromView: self.contentView.coverView)
        }
    }
    
}

// MARK: - User interactions

private extension DetailSongView {
    
    @objc
    func didTapDismissBarButton() {
        presenter?.dismissAction()
    }
    
    @objc
    func didTapAddToFavorite() {
        presenter?.saveToFavorite()
        presenter?.viewDidLoad()
    }
    
}

// MARK: - DetailSongViewProtocol

extension DetailSongView: DetailSongViewProtocol {
    
    func setupContent(withState state: DetailSongEntity, withHorizontalActionMenuItem horizontalActionMenuItem: [HorizontalActionMenuItem]) {
        contentView
            .set(state: state)
            .make {
                $0.horizontalActionMenuView.set(menuItems: horizontalActionMenuItem)
            }
    }
    
    func setFavoriteStatus(_ isSaved: Bool) {
        let rightImage = UIImage(systemName: isSaved ? "heart.fill" : "heart")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: rightImage,
            style: .plain,
            target: self,
            action: #selector(didTapAddToFavorite)
        )
    }
    
    func setCoverAnimation(animationState: CoverViewAnimation, completion: (() -> Void)?) {
        contentView.set(animationState: animationState, completion: completion)
    }
    
    func showCopiedToast() {
        contentView.copiedToast.show(haptic: .success)
    }
    
    func showUnavailableToast() {
        contentView.unvailableToast.show(haptic: .warning)
    }
    
    func stopShareLoading() {
        contentView.horizontalActionMenuView.set(animationStyle: .normal)
    }
    
    func showError(_ error: String) {
        showAlert(title: "Ooops...", message: error, alertAction: stopShareLoading)
    }
    
    func showAlertShareCount(for shareMedia: ShareMediaResponse) {
        let sourceIds = shareMedia.items.map { $0.songSourceId }
        
        showAlert(title: "Sorry, we have problem", message: "Make and send screenshot to us \nids:\(sourceIds)")
    }
    
    func showSavedImage() {
        contentView.imageSavedToast.show(haptic: .success)
    }
    
    func stopLoadingAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.contentView.horizontalActionMenuView.set(animationStyle: .normal)
        }
    }
    
}

// MARK: - HorizontalActionMenuDelegate

extension DetailSongView: HorizontalActionMenuDelegate {
    
    func didTapActionItem(
        _ horizontalActionMenuView: HorizontalActionMenuView,
        action: HorizontalMenuAction,
        available: Bool,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard available else {
            showUnavailableToast()
            return
        }
        
        switch action {
        case .shareAppleMusicLink, .shareSpotifyLink:
            presenter?.didTapShareMedia(for: action.rawValue)
            
        case .shareYouTubeMusicLink:
            stopLoadingAnimation()
            
        case .shareCover:
            guard let coverImage = contentView.makeImage() else { return }

            presenter?.shareCover(cover: coverImage)
            
        case .saveCover:
            guard let cover = contentView.cover else { return }
            
            presenter?.saveCover(cover: cover)
            
        case .makeCover:
            presenter?.didTapMakeCover()
            stopLoadingAnimation()
        }
    }
    
}
