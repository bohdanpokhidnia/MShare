//
//  FavoritesInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.10.2022.
//

import Foundation

protocol FavoritesInteractorIntputProtocol {
    var presenter: FavoritesInteractorOutputProtocol? { get set }
}

protocol FavoritesInteractorOutputProtocol: AnyObject {
    
}

final class FavoritesInteractor {
    weak var presenter: FavoritesInteractorOutputProtocol?
}

// MARK: - FavoritesInteractorInputProtocol

extension FavoritesInteractor: FavoritesInteractorIntputProtocol {
    
}
