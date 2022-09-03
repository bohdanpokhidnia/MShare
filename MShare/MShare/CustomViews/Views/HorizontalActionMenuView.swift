//
//  HorizontalActionMenuView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 11.08.2022.
//

import UIKit
import SnapKit

protocol HorizontalActionMenuDelegate: AnyObject {
    func didTapActionItem(_ horizontalActionMenuView: HorizontalActionMenuView, action: HorizontalMenuAction, didSelectItemAt indexPath: IndexPath)
}

enum HorizontalMenuAction: CaseIterable {
    case shareAppleMusicLink
    case shareSpotifyLink
    case shareCover
    
    var image: UIImage? {
        switch self {
        case .shareAppleMusicLink:
            return UIImage(named: "appleMusicLogo")
            
        case .shareSpotifyLink:
            return UIImage(named: "spotifyLogo")
            
        case .shareCover:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .shareAppleMusicLink:
            return "Apple Music"
            
        case .shareSpotifyLink:
            return "Spotify"
            
        case .shareCover:
            return "Share cover"
        }
    }
    
}

final class HorizontalActionMenuView: View {
    
    static let HorizontalActionMenuWidth: CGFloat = (UIScreen.main.bounds.width / 3)
    static let HorizontalActionMenuHeight: CGFloat = (UIScreen.main.bounds.height / 4)
    
    weak var delegare: HorizontalActionMenuDelegate?
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.sectionInset = .init(horizontal: 16)
        collectionViewFlowLayout.minimumLineSpacing = 10
        
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
        
        menuActions = HorizontalMenuAction.allCases
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
    private var menuActions = [HorizontalMenuAction]()
    
}

// MARK: - Set

extension HorizontalActionMenuView {
    
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
        return menuActions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let action = menuActions[indexPath.row]
        
        let cell = collectionView.dequeue(HorizontalActionMenuViewCell.self, for: indexPath)
        return cell.set(state: .init(image: action.image, title: action.title))
    }
    
}

// MARK: - UICollectionViewDelegate

extension HorizontalActionMenuView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = menuActions[indexPath.row]
        
        selectedIndexPath = indexPath
        set(animationStyle: .blurred)
        
        delegare?.didTapActionItem(self, action: action, didSelectItemAt: indexPath)
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
