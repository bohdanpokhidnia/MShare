//
//  DetailSongView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit

protocol SongDetailsViewProtocol: BaseView {
    var presenter: SongDetailsPresenterProtocol? { get set }
    var viewController: UIViewController { get }
    var shortToastPositionY: CGFloat { get }
    
    func setupContent(withState state: SongDetailsEntity, withHorizontalActionMenuItem horizontalActionMenuItem: [HorizontalActionMenuItem])
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

final class SongDetailsView: ViewController<SongDetailsContentView> {
    var presenter: SongDetailsPresenterProtocol?
    var viewController: UIViewController { self }
    var shortToastPositionY: CGFloat { contentView.shortToastPositionY }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupViews()
        setupActionsHandler()
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationControllerDelegate = navigationController?.delegate as? AppNavigationControllerDelegate
    }
    
    // MARK: - Private
    
    private var startY: CGFloat = 0
    private var navigationControllerDelegate: AppNavigationControllerDelegate?
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(panInteractive))
}

// MARK: - Setup

private extension SongDetailsView {
    func setupNavigationBar() {
        let closeImageView = UIImage(systemName: "xmark.circle.fill")?
            .resizeImage(newWidth: 32.0)?
            .applyGradient(colors: [.appPink, .appBlue], start: .topLeading, end: .bottomTrailing)?
            .withRenderingMode(.alwaysOriginal)
        
        let closeButtonItem = UIBarButtonItem(
            image: closeImageView,
            style: .done,
            target: self,
            action: #selector(didTapCloseBarButton)
        )
        
        navigationItem.titleView = contentView.gradientTitleLabel
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = closeButtonItem
    }
    
    func setupViews() {
        contentView.horizontalActionMenuView.delegare = self
    }
    
    func setupActionsHandler() {
        contentView.addGestureRecognizer(panGesture)
        
        contentView.coverView.onTap = { [unowned self] in
            presenter?.copyCoverToBuffer(fromView: self.contentView.coverView)
        }
    }
}

// MARK: - User interactions

private extension SongDetailsView {
    @objc
    func didTapCloseBarButton() {
        presenter?.didTapPop()
    }
    
    @objc
    func didTapAddToFavorite() {
        presenter?.saveToFavorite()
        presenter?.viewDidLoad()
    }
    
    @objc
    func panInteractive(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let percent = min(1, max(0, (translation.y - startY) / 200))
        
        switch sender.state {
        case .began:
            startY = translation.y
            navigationControllerDelegate?.interactiveTransition = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewController(animated: true)
            
        case .changed:
            navigationControllerDelegate?.interactiveTransition?.update(percent)
            
        case .cancelled, .ended:
            if sender.velocity(in: sender.view).y < 0 && percent < 0.5 {
                navigationControllerDelegate?.interactiveTransition?.cancel()
            } else {
                navigationControllerDelegate?.interactiveTransition?.finish()
            }
            
            navigationControllerDelegate?.interactiveTransition = nil
            
        default:
            break
        }
    }
}

// MARK: - HorizontalActionMenuDelegate

extension SongDetailsView: HorizontalActionMenuDelegate {
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
            guard let coverImage = contentView.makeImage() else {
                return
            }

            presenter?.shareCover(cover: coverImage)
            
        case .saveCover:
            guard let cover = contentView.cover else {
                return
            }
            
            presenter?.saveCover(cover: cover)
        }
    }
}

//MARK: - TransitionProtocol

extension SongDetailsView: TransitionProtocol {
    var transitionView: UIView {
       return contentView
    }
    
    func viewsToAnimate() -> [UIView] {
        return [
            contentView.coverView.coverImageView,
            contentView.coverView.songNameLabel,
            contentView.coverView.artistNameLabel
        ]
    }
    
    func copyForView(_ subView: UIView) -> UIView {        
        switch subView {
        case contentView.coverView.coverImageView:
            let imageViewCopy = UIImageView(image: contentView.cover)
                .setCornerRadius(5)
                .maskToBounds(true)
            
            return imageViewCopy
            
        case contentView.coverView.songNameLabel:
            let songNameLabel = UILabel()
                .text(contentView.coverView.songNameLabel.text)
                .textColor(.label)
            
            return songNameLabel
            
        case contentView.coverView.artistNameLabel:
            let artistNameLabel = UILabel()
                .text(contentView.coverView.artistNameLabel.text)
                .textColor(.secondaryLabel)
            
            return artistNameLabel
            
        default:
            fatalError("don't found transition view")
        }
    }
    
    func resizableTransitions() -> [ResizableTransition] {
        let gradientView = contentView.coverView.gradientBackgroundView
        let fromFrameOrigin = CGPoint(x: contentView.center.x, y: contentView.center.y / 2)
        let fromFrame = CGRect(origin: fromFrameOrigin, size: .zero)
        let toFrame = gradientView.superview?.convert(gradientView.frame, to: nil) ?? .zero
        
        let shadowView = contentView.coverViewContainer
        
        return [
            .init(view: gradientView, from: fromFrame, to: toFrame),
            .init(view: shadowView, from: .init(origin: .zero, size: .zero), to: toFrame)
        ]
    }
    
    func copyViewForResizableView(_ subView: UIView) -> UIView {
        switch subView {
        case contentView.coverView.gradientBackgroundView:
            return GradientView()
                .set(colors: [.appPink, .appPink, .appBlue, .appBlue])
                .set(startPoint: .topLeading, endPoint: .bottomTrailing)
                .setCornerRadius(28)
                .maskToBounds(true)
                .make {
                    $0.bounds = .init(origin: .zero, size: contentView.coverView.gradientBackgroundView.frame.size)
                }
            
        case contentView.coverViewContainer:
            return ViewLayoutable()
                .maskToBounds(false)
                .setCornerRadius(28)
                .addShadow(color: .clear, offset: .init(width: 4, height: 4), opacity: 0.3, radius: 10)
            
        default:
            fatalError("don't found view for copy")
        }
    }
}

// MARK: - SongDetailsViewProtocol

extension SongDetailsView: SongDetailsViewProtocol {
    func setupContent(withState state: SongDetailsEntity, withHorizontalActionMenuItem horizontalActionMenuItem: [HorizontalActionMenuItem]) {
        contentView
            .set(state: state)
            .make {
                $0.horizontalActionMenuView.set(menuItems: horizontalActionMenuItem)
            }
    }
    
    func setFavoriteStatus(_ isSaved: Bool) {
        let heartImage = UIImage(systemName: isSaved ? "heart.fill" : "heart")?
            .resizeImage(newWidth: 32.0)?
            .applyGradient(colors: [.appPink, .appBlue], start: .topLeading, end: .bottomTrailing)?
            .withRenderingMode(.alwaysOriginal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: heartImage,
            style: .done,
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
