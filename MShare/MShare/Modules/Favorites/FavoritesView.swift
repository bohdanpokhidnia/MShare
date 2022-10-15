//
//  FavoritesView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.10.2022.
//

import UIKit

protocol FavoritesViewProtocol: AnyObject {
    var presenter: FavoritesPresenterProtocol? { get set }
    var viewController: UIViewController { get }
}

final class FavoritesView: ViewController<FavoritesContentView> {
    
    var presenter: FavoritesPresenterProtocol?
    
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        contentView.backgroundColor = .systemOrange
    }

}

// MARK: - FavoritesViewProtocol

extension FavoritesView: FavoritesViewProtocol {
    
}
