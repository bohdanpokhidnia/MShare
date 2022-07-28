//
//  SearchInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import Foundation

protocol SearchInteractorIntputProtocol {
    var presenter: SearchInteractorOutputProtocol? { get set }
}

protocol SearchInteractorOutputProtocol: AnyObject {
    
}

final class SearchInteractor {
    weak var presenter: SearchInteractorOutputProtocol?
}

// MARK: - SearchInteractorInputProtocol

extension SearchInteractor: SearchInteractorIntputProtocol {
    
}
