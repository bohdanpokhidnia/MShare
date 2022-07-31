//
//  UITableView+Ext.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 30.07.2022.
//

import UIKit

extension UITableView {
    
    /// Register nib for reuse
    @discardableResult
    func register<T: UITableViewCell>(nib cell: T.Type) -> Self {
        let className = String(describing: cell)
        register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
        return self
    }
    
    /// Register class for reuse
    @discardableResult
    func register<T: UITableViewCell>(class cell: T.Type) -> Self {
        let className = String(describing: cell)
        register(cell.self, forCellReuseIdentifier: className)
        return self
    }
    
    @discardableResult
    func register(classes cells: UITableViewCell.Type...) -> Self {
        cells.forEach { register(nib: $0) }
        return self
    }
    
    /// Returns reusable cell
    func dequeue<T: UITableViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        let className = String(describing: cell)
        let cell = dequeueReusableCell(withIdentifier: className, for: indexPath)
        return cell as! T
    }
    
}
