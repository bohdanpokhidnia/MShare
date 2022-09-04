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
    
    static let HorizontalActionMenuWidth: CGFloat = calculateSize(by: UIScreen.phone).width
    static let HorizontalActionMenuHeight: CGFloat = calculateSize(by: UIScreen.phone).height
    
    weak var delegare: HorizontalActionMenuDelegate?
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.sectionInset = .init(horizontal: 16)
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
    
    static func calculateSize(by phone: UIScreen.Phone) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch phone {
        case .iPhoneSE1:
            width = UIScreen.main.bounds.width / 3
            height = UIScreen.main.bounds.height / 4
            
        case .iPhone6_7_8_SE2_SE3:
            width = UIScreen.main.bounds.width / 3
            height = UIScreen.main.bounds.height / 4
            
        case .iPhone6_7_8Plus:
            width = UIScreen.main.bounds.width / 3
            height = UIScreen.main.bounds.height / 4
            
        case .iPhoneX_11Pro_12Mini_13Mini:
            width = UIScreen.main.bounds.width / 3
            height = UIScreen.main.bounds.height / 4
            
        case .iPhoneXr_XsMax_11_12:
            width = UIScreen.main.bounds.width / 3
            height = UIScreen.main.bounds.height / 4
            
        case .iPhone12Pro_13_13Pro:
            width = UIScreen.main.bounds.width / 3
            height = UIScreen.main.bounds.height / 4
            
        case .iPhone12_13ProMax:
            width = UIScreen.main.bounds.width / 3 - 10
            height = UIScreen.main.bounds.height / 5
            
        case .unknown:
            width = UIScreen.main.bounds.width / 3
            height = UIScreen.main.bounds.height / 4
        }
        
        return .init(width: width, height: height)
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
