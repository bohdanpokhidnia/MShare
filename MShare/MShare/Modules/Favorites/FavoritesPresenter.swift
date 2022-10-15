//
//  FavoritesPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.10.2022.
//

import Foundation

protocol FavoritesPresenterProtocol: AnyObject {
    var view: FavoritesViewProtocol? { get set }
    var interactor: FavoritesInteractorIntputProtocol? { get set }
    var router: FavoritesRouterProtocol? { get set }
}

final class FavoritesPresenter {
    var view: FavoritesViewProtocol?
    var interactor: FavoritesInteractorIntputProtocol?
    var router: FavoritesRouterProtocol?
}

// MARK: - FavoritesPresenterProtocol

extension FavoritesPresenter: FavoritesPresenterProtocol {
    
}

// MARK: - FavoritesInteractorOutputProtocol

extension FavoritesPresenter: FavoritesInteractorOutputProtocol {
    
}
