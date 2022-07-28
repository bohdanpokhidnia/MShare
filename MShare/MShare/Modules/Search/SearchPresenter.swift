//
//  SearchPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import Foundation

protocol SearchPresenterProtocol: AnyObject {
    var view: SearchViewProtocol? { get set }
    var interactor: SearchInteractorIntputProtocol? { get set }
    var router: SearchRouterProtocol? { get set }
}

final class SearchPresenter {
    var view: SearchViewProtocol?
    var interactor: SearchInteractorIntputProtocol?
    var router: SearchRouterProtocol?
}

// MARK: - SearchPresenterProtocol

extension SearchPresenter: SearchPresenterProtocol {
    
}

// MARK: - SearchInteractorOutputProtocol

extension SearchPresenter: SearchInteractorOutputProtocol {
    
}
