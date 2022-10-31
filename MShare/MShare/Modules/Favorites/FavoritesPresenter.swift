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
    
    func viewWillAppear()
    func mediaSectionsCount() -> Int
    func mediaCount(by mediaType: MediaType) -> Int
    func metdiaItem(forIndexPath indexPath: IndexPath) -> MediaItem?
    func shareUrl(forIndexPath indexPath: IndexPath)
    func didTapMediaItem(forIndexPath indexPath: IndexPath)
}

final class FavoritesPresenter {
    var view: FavoritesViewProtocol?
    var interactor: FavoritesInteractorIntputProtocol?
    var router: FavoritesRouterProtocol?
    
    private var songs = [MediaModel]()
    private var albums = [MediaModel]()
}

// MARK: - FavoritesPresenterProtocol

extension FavoritesPresenter: FavoritesPresenterProtocol {
    
    func viewWillAppear() {
        interactor?.loadMedia()
    }
    
    func mediaSectionsCount() -> Int {
        var count = 0
        
        count += songs.count > 0 ? 1 : 0
        count += albums.count > 0 ? 1 : 0
        
        return count
    }
    
    func mediaCount(by mediaType: MediaType) -> Int {
        switch mediaType {
        case .song:
            return songs.count
            
        case .album:
            return albums.count
        }
    }
    
    func metdiaItem(forIndexPath indexPath: IndexPath) -> MediaItem? {
        guard let mediaModel = getMediaModel(forIndexPath: indexPath) else { return nil }
        let mediaItem = MediaItem(title: mediaModel.name,
                                  subtitle: mediaModel.artistName,
                                  imageURL: mediaModel.coverImageUrl,
                                  displayShareButton: true)
        return mediaItem
    }
    
    func shareUrl(forIndexPath indexPath: IndexPath) {
        guard let mediaModel = getMediaModel(forIndexPath: indexPath) else { return }
        
        router?.shareUrl(view: view, urlString: mediaModel.url)
    }
    
    func didTapMediaItem(forIndexPath indexPath: IndexPath) {
        guard let mediaModel = getMediaModel(forIndexPath: indexPath) else { return }
        
        router?.presentDetailSongScreen(fromView: view, mediaModel: mediaModel)
    }
    
}

// MARK: - FavoritesInteractorOutputProtocol

extension FavoritesPresenter: FavoritesInteractorOutputProtocol {
    
    func didLoadMedia(_ songs: [MediaModel], _ albums: [MediaModel]) {
        self.songs.removeAll()
        self.albums.removeAll()
        
        self.songs = songs
        self.albums = albums
    }
    
}

// MARK: - Private Methods

private extension FavoritesPresenter {
    
    func getMediaModel(forIndexPath indexPath: IndexPath) -> MediaModel? {
        guard let section = FavoritesView.FavoriteSection(rawValue: indexPath.section) else { return nil }
        let row = indexPath.row
        var mediaModel: MediaModel?
        
        switch section {
        case .song:
            mediaModel = songs[row]
            
        case .album:
            mediaModel = albums[row]
        }
        
        return mediaModel
    }
    
}
