//
//  SongDetailsContentView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit
import SnapKit
import NotificationToast

final class SongDetailsContentView: ViewLayoutable {
    var cover: UIImage? {
        return coverView.coverImageView.image
    }
    
    var shortToastPositionY: CGFloat {
        let y = coverCenterY - 25.0
        return y
    }
    
    // MARK: - UI
    
    private(set) var copiedToast = ToastView(
        title: "Cover copied",
        titleFont: .systemFont(ofSize: 13, weight: .regular),
        icon: UIImage(systemName: "doc.on.doc.fill"),
        iconSpacing: 16,
        position: .top
    )
    
    private(set) var unvailableToast = ToastView(
        title: "The service will be available soon",
        titleFont: .systemFont(ofSize: 13, weight: .regular),
        icon: UIImage(systemName: "xmark"),
        iconSpacing: 12,
        position: .top
    )
    
    private(set) var imageSavedToast = ToastView(
        title: "Image saved successfuly",
        titleFont: .systemFont(ofSize: 13, weight: .regular),
        icon: UIImage(systemName: "photo.on.rectangle.angled"),
        iconSpacing: 14,
        position: .top
    )
    
    private let backgroundImageView = UIImageView()
        .setContentMode(.scaleAspectFill)
        .addClearBackgroundBlur(style: .regular)
    
    private(set) var coverViewContainer = ViewLayoutable()
        .maskToBounds(false)
        .setCornerRadius(28)
        .addShadow(color: .black, offset: .init(width: 4, height: 4), opacity: 0.3, radius: 10)
    
    private(set) var coverView = CoverView()
    
    private(set) var horizontalActionMenuView = HorizontalActionMenuView()
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        backgroundColor(color: .white)
        maskToBounds(true)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        coverViewContainer.addSubview(coverView)
        addSubviews(
            backgroundImageView,
            coverViewContainer,
            horizontalActionMenuView
        )
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        coverViewContainer.snp.makeConstraints {
            $0.centerY.equalTo(coverCenterY)
            $0.centerX.equalToSuperview()
        }
        
        coverView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        horizontalActionMenuView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-horizontalActionMenuOffset)
            $0.height.equalTo(horizontalActionMenuHeight)
        }
    }
    
    // MARK: - Private
    
    private let screenHeight = UIApplication.windowScene.screen.bounds.height
    private let horizontalActionMenuHeight = HorizontalActionMenuView.itemSize.height + 32.0
    private let horizontalActionMenuOffset: CGFloat = 16.0
    private let coverMinY: CGFloat = UIApplication.safeAreaInsets.top
    private lazy var coverMaxY: CGFloat = screenHeight - (UIApplication.safeAreaInsets.bottom + horizontalActionMenuHeight + horizontalActionMenuOffset)
    private lazy var coverCenterY: CGFloat = (coverMaxY + coverMinY) / 2
}

// MARK: - Set

extension SongDetailsContentView {
    @discardableResult
    func set(state: SongDetailsEntity) -> Self {
        backgroundImageView.setImage(state.image)
        coverView.set(state: state)
        return self
    }
    
    @discardableResult
    func set(animationState: CoverViewAnimation, completion: (() -> Void)? = nil) -> Self {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 5,
            options: [.allowUserInteraction],
            animations: {
                self.coverViewContainer.transform = animationState.animation
            }, completion: { _ in
                completion?()
            }
        )
        return self
    }
    
    func makeImage() -> UIImage? {
        horizontalActionMenuView.isHidden = true
        
        let oldCoverCenter = coverViewContainer.center
        coverViewContainer.center = center
        
        defer {
            horizontalActionMenuView.isHidden = false
            coverViewContainer.center = oldCoverCenter
        }
        
        let snapshotImage = makeSnapShotImage(withBackground: true)
        return snapshotImage
    }
}
