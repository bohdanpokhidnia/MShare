//
//  DetailSongInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import Foundation

protocol DetailSongInteractorIntputProtocol {
    var presenter: DetailSongInteractorOutputProtocol? { get set }
}

protocol DetailSongInteractorOutputProtocol: AnyObject {
    
}

final class DetailSongInteractor {
    weak var presenter: DetailSongInteractorOutputProtocol?
}

// MARK: - DetailSongInteractorInputProtocol

extension DetailSongInteractor: DetailSongInteractorIntputProtocol {
    
}
