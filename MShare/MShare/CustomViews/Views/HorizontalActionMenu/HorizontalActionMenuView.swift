//
//  HorizontalActionMenuView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 11.08.2022.
//

import UIKit
import SnapKit

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
        guard let indexPath = indexPath else {
            return
        }
        let cell = collectionView.cellForItem(HorizontalActionMenuViewCell.self, at: indexPath)
        
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
