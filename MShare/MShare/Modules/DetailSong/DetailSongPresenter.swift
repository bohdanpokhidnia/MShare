//
//  DetailSongPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import Foundation

protocol DetailSongPresenterProtocol: AnyObject {
    var view: DetailSongViewProtocol? { get set }
    var interactor: DetailSongInteractorIntputProtocol? { get set }
    var router: DetailSongRouterProtocol? { get set }
}

final class DetailSongPresenter {
    var view: DetailSongViewProtocol?
    var interactor: DetailSongInteractorIntputProtocol?
    var router: DetailSongRouterProtocol?
}

// MARK: - DetailSongPresenterProtocol

extension DetailSongPresenter: DetailSongPresenterProtocol {
    
}

// MARK: - DetailSongInteractorOutputProtocol

extension DetailSongPresenter: DetailSongInteractorOutputProtocol {
    
}
