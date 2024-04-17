//
//  UICollectionView+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 30.07.2022.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(class cell: T.Type) {
        let className = String(describing: cell)
        register(cell, forCellWithReuseIdentifier: className)
    }
    
    func dequeue<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        let className = String(describing: cell)
        let cell = dequeueReusableCell(withReuseIdentifier: className, for: indexPath)
        return cell as! T
    }
    
    @discardableResult
    func dataSourced(_ dataSource: UICollectionViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    @discardableResult
    func delegated(_ delegate: UICollectionViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    func cellForItem<T: UICollectionViewCell>(_ cellType: T.Type, at indexPath: IndexPath) -> T {
        let cell = cellForItem(at: indexPath) as! T
        return cell
    }
}
