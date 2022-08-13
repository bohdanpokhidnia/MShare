//
//  HorizontalActionMenuView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 11.08.2022.
//

import UIKit
import SnapKit

protocol HorizontalActionMenuDelegate: AnyObject {
    func didTapActionItem(_ action: HorizontalMenuAction)
}

enum HorizontalMenuAction: CaseIterable {
    case shareLink
    case shareCover
    case shareLink1
    case shareCover1
    case shareLink2
    case shareCover2
    
    var image: UIImage? {
        switch self {
        case .shareLink:
            return UIImage(systemName: "link")
            
        case .shareCover:
            return UIImage(systemName: "photo.artframe")
            
        case .shareLink1:
            return UIImage(systemName: "link")
            
        case .shareCover1:
            return UIImage(systemName: "photo.artframe")
            
        case .shareLink2:
            return UIImage(systemName: "link")
            
        case .shareCover2:
            return UIImage(systemName: "photo.artframe")
        }
    }
    
    var title: String {
        switch self {
        case .shareLink:
            return "Link"
            
        case .shareCover:
            return "Cover"
            
        case .shareLink1:
            return "Link 1"
            
        case .shareCover1:
            return "Cover 1"
            
        case .shareLink2:
            return "Link 2"
            
        case .shareCover2:
            return "Cover 2"
        }
        
    }
}

final class HorizontalActionMenuView: View {
    
    weak var delegare: HorizontalActionMenuDelegate?
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        collectionViewFlowLayout.sectionInset = .init(horizontal: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(class: HorizontalActionMenuViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .normal
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
    
    private var menuActions = [HorizontalMenuAction]()
    
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
        
        delegare?.didTapActionItem(action)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HorizontalActionMenuView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width / 4
        let height: CGFloat = collectionView.bounds.height
        
        return .init(width: width, height: height)
    }
    
}
