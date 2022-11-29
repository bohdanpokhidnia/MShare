//
//  HorizontalActionMenuView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 11.08.2022.
//

import UIKit
import SnapKit

protocol HorizontalActionMenuDelegate: AnyObject {
    func didTapActionItem(_ horizontalActionMenuView: HorizontalActionMenuView,
                          action: HorizontalMenuAction,
                          available: Bool,
                          didSelectItemAt indexPath: IndexPath)
}

enum HorizontalMenuAction: String, CaseIterable {
    case shareAppleMusicLink = "AppleMusic"
    case shareSpotifyLink = "Spotify"
    case shareYouTubeMusicLink = "YoutubeMusic"
    case shareCover
    
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
        }
    }
    
}

final class HorizontalActionMenuView: View {
    
    static let HorizontalActionMenuWidth: CGFloat = calculateSize(forPhone: UIDevice.phone).width
    static let HorizontalActionMenuHeight: CGFloat = calculateSize(forPhone: UIDevice.phone).height
    
    weak var delegare: HorizontalActionMenuDelegate?
    
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
    
    static func calculateSize(forPhone phone: UIDevice.Phone) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch phone {
        case .iPhoneSE:
            width = UIScreen.main.bounds.width / 3
            height = UIScreen.main.bounds.height / 4
            
//        case .iPhone6_7_8_SE2_SE3
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8:
            width = UIScreen.main.bounds.width / 3
            height = UIScreen.main.bounds.height / 4
            
//        case .iPhone6_7_8Plus:
        case .iPhone6Plus, .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            width = UIScreen.main.bounds.width / 3
            height = UIScreen.main.bounds.height / 4
            
//        case .iPhoneXr_XsMax_11_12, .iPhone12Pro_13_13Pro_14, .iPhoneX_11Pro_12Mini_13Mini, .iPhone12_13ProMax_14Plus, .iPhone14Pro, .iPhone14ProMax:
        case .iPhoneXR, .iPhoneXS, .iPhoneXSMax, .iPhone11, .iPhone11ProMax, .iPhone12, .iPhone12Pro, .iPhone12ProMax, .iPhone13, .iPhone13Pro, .iPhone14, .iPhoneX, .iPhone11Pro, .iPhone12Mini, .iPhone13Mini, .iPhone13ProMax, .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax:
            width = UIScreen.main.bounds.width / 3 - 10
            height = UIScreen.main.bounds.height / 5
            
        case .simulator, .unrecognized:
            width = UIScreen.main.bounds.width / 3
            height = UIScreen.main.bounds.height / 4
        }
        
        return .init(width: width, height: height)
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
        let width: CGFloat = Self.HorizontalActionMenuWidth
        let height: CGFloat = Self.HorizontalActionMenuHeight
        
        return .init(width: width, height: height)
    }
    
}
