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
    func removeMedia(forIndexPath indexPath: IndexPath, _ mediaModel: MediaModel)
    func loadFavoriteSection()
}

protocol FavoritesInteractorOutputProtocol: AnyObject {
    func didLoadMedia(_ songs: [MediaModel], _ albums: [MediaModel])
    func didRemoveMedia(forIndexPath indexPath: IndexPath, error: DBError?)
    func didLoadFavoriteSection(_ sectionIndex: Int)
}

final class FavoritesInteractor {
    weak var presenter: FavoritesInteractorOutputProtocol?
    
    private var userManager: UserManagerProtocol
    private var databaseManager: DatabaseManagerProtocol
    
    init(userManager: UserManagerProtocol, databaseManager: DatabaseManagerProtocol) {
        self.userManager = userManager
        self.databaseManager = databaseManager
    }
}

// MARK: - FavoritesInteractorInputProtocol

extension FavoritesInteractor: FavoritesInteractorIntputProtocol {
    
    func loadMedia() {
        let songs = databaseManager.getMediaModels(by: .song)
        let albums = databaseManager.getMediaModels(by: .album)
        
        presenter?.didLoadMedia(songs, albums)
    }
    
    func removeMedia(forIndexPath indexPath: IndexPath, _ mediaModel: MediaModel) {
        databaseManager.delete(mediaModel) { [weak presenter] (error) in
            presenter?.didRemoveMedia(forIndexPath: indexPath, error: error)
        }
    }
    
    func loadFavoriteSection() {
        let sectionIndex = userManager.favoriteFirstSection ?? 0
        
        presenter?.didLoadFavoriteSection(sectionIndex)
    }
    
}
