//
//  FavoritesInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.10.2022.
//

import UIKit

protocol FavoritesInteractorIntputProtocol {
    var presenter: FavoritesInteractorOutputProtocol? { get set }
    
    func loadMedia()
    func removeMedia(forIndexPath indexPath: IndexPath, _ mediaModel: MediaModel)
    func loadFavoriteSection()
    func mapModelToResponse(mediaModel: MediaModel)
}

protocol FavoritesInteractorOutputProtocol: AnyObject {
    func didLoadMedia(_ songs: [MediaModel], _ albums: [MediaModel])
    func didRemoveMedia(forIndexPath indexPath: IndexPath, error: DBError?)
    func didLoadFavoriteSection(_ sectionIndex: Int)
    func didMapModelToResponse(mediaResponse: MediaResponse, cover: UIImage)
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
        let songs = databaseManager
            .getMediaModels(by: .song)
            .reversed()
            .map { $0 }
        let albums = databaseManager
            .getMediaModels(by: .album)
            .reversed()
            .map { $0 }
        
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
    
    func mapModelToResponse(mediaModel: MediaModel) {
        guard let coverImage = UIImage(data: mediaModel.coverData),
              let mediaType = MediaType(rawValue: mediaModel.mediaType)
        else { return }
        
        var song: Song?
        var album: Album?
        let services: [MediaService] = mediaModel.services.map { (service) in
            .init(name: service.name, type: service.type, isAvailable: service.isAvailable)
        }
        
        switch mediaType {
        case .song:
            song = Song(
                songSourceId: mediaModel.sourceId,
                songUrl: mediaModel.url,
                songName: mediaModel.name,
                artistName: mediaModel.artistName,
                albumName: mediaModel.albumName,
                coverImageUrl: mediaModel.coverImageUrl,
                serviceType: mediaModel.serviceType
            )
            
        case .album:
            album = Album(
                albumSourceId: mediaModel.sourceId,
                albumUrl: mediaModel.url,
                albumName: mediaModel.albumName,
                artistName: mediaModel.artistName,
                coverImageUrl: mediaModel.coverImageUrl,
                serviceType: mediaModel.serviceType
            )
        }
        
        let mediaResponse = MediaResponse(
            mediaType: mediaType,
            song: song,
            album: album,
            services: services
        )
        
        presenter?.didMapModelToResponse(mediaResponse: mediaResponse, cover: coverImage)
    }
    
}
