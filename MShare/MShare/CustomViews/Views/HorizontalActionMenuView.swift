//
//  HorizontalActionMenuView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 11.08.2022.
//

import UIKit
import SnapKit

protocol HorizontalActionMenuDelegate: AnyObject {
    func didTapActionItem(
        _ horizontalActionMenuView: HorizontalActionMenuView,
        action: HorizontalMenuAction,
        available: Bool,
        didSelectItemAt indexPath: IndexPath
    )
}

enum HorizontalMenuAction: String, CaseIterable {
    case shareAppleMusicLink = "AppleMusic"
    case shareSpotifyLink = "Spotify"
    case shareYouTubeMusicLink = "YoutubeMusic"
    case shareCover
    case saveCover
    case makeCover
    
    var image: UIImage? {
        switch self {
        case .shareAppleMusicLink:
            return UIImage(named: "appleMusicLogo")
            
        case .shareSpotifyLink:
            return UIImage(named: "spotifyLogo")
            
        case .shareYouTubeMusicLink:
            return UIImage(named: "youtubeMusicLogo")
            
        case .shareCover:
            return UIImage(named: "coverShareIcon")
            
        case .saveCover:
            return UIImage(named: "saveCoverIcon")
            
        case .makeCover:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .shareAppleMusicLink:
            return "Apple Music"
            
        case .shareSpotifyLink:
            return "Spotify"
            
        case .shareYouTubeMusicLink:
            return "YouTube Music"
            
        case .shareCover:
            return "Share cover"
            
        case .saveCover:
            return "Save cover"
            
        case .makeCover:
            return "Make cover"
        }
    }
    
}

final class HorizontalActionMenuView: ViewLayoutable {
    weak var delegare: HorizontalActionMenuDelegate?
    
    static var itemSize: CGSize {
        let screenSize = UIApplication.windowScene.screen.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let width: CGFloat
        let height: CGFloat
        
        if UIApplication.isSmallScreenRatio {
            width = screenWidth / 3
            height = screenHeight / 4
        } else {
            width = screenWidth / 3 - 10
            height = screenHeight / 5
        }
        
        let size = CGSize(width: width, height: height)
        return size
    }
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(horizontal: 16)
        collectionViewFlowLayout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(class: HorizontalActionMenuViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor(color: .clear)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(collectionView)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Private
    
    private var selectedIndexPath: IndexPath?
    private var menuItems = [HorizontalActionMenuItem]()
}

// MARK: - Set

extension HorizontalActionMenuView {
    @discardableResult
    func set(menuItems: [HorizontalActionMenuItem]) -> Self {
        self.menuItems = menuItems
        return self
    }
    
    @discardableResult
    func set(animationStyle: HorizontalActionAnimationType) -> Self {
        switch animationStyle {
        case .blurred:
            changeAnimationActionMenu(by: selectedIndexPath, animationStyle: .blurred)
            
        case .normal:
            changeAnimationActionMenu(by: selectedIndexPath, animationStyle: .normal)
            selectedIndexPath = nil
        }
        
        return self
    }
}

// MARK: - Private Methods

private extension HorizontalActionMenuView {
    func changeAnimationActionMenu(by indexPath: IndexPath?, animationStyle: HorizontalActionAnimationType) {
        guard let indexPath = indexPath,
              let cell = collectionView.cellForItem(at: indexPath) as? HorizontalActionMenuViewCell
        else { return }
        
        cell.set(style: animationStyle)
    }
}

// MARK: - UICollectionViewDataSource

extension HorizontalActionMenuView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let menuItem = menuItems[indexPath.row]
        let cell = collectionView.dequeue(HorizontalActionMenuViewCell.self, for: indexPath)
        return cell.set(state: menuItem)
    }
}

// MARK: - UICollectionViewDelegate

extension HorizontalActionMenuView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        selectedIndexPath = indexPath
        
        if menuItem.active {
            set(animationStyle: .blurred)
        }
        
        delegare?.didTapActionItem(self, action: menuItem.action, available: menuItem.active, didSelectItemAt: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HorizontalActionMenuView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = Self.itemSize
        return size
    }
}
