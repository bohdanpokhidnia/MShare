//
//  FavoritesInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.10.2022.
//

import Foundation

protocol FavoritesInteractorIntputProtocol {
    var presenter: FavoritesInteractorOutputProtocol? { get set }
    
    func loadMedia()
}

protocol FavoritesInteractorOutputProtocol: AnyObject {
    func didLoadMedia(_ songs: [MediaModel], _ albums: [MediaModel])
}

final class FavoritesInteractor {
    weak var presenter: FavoritesInteractorOutputProtocol?
    
    private let databaseManager: DatabaseManagerProtocol = DatabaseManager()
}

// MARK: - FavoritesInteractorInputProtocol

extension FavoritesInteractor: FavoritesInteractorIntputProtocol {
    
    func loadMedia() {
        let songs = databaseManager.getMediaModels(by: .song)
        let albums = databaseManager.getMediaModels(by: .album)
        
        presenter?.didLoadMedia(songs, albums)
    }
    
}
