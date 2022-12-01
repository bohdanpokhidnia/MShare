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
    
    func viewDidLoad()
    func viewWillAppear()
    func mediaCount() -> Int
    func metdiaItem(forIndexPath indexPath: IndexPath) -> MediaItem?
    func shareUrl(forIndexPath indexPath: IndexPath)
    func tapOnMediaItem(forIndexPath indexPath: IndexPath)
    func removeMediaItem(forIndexPath indexPath: IndexPath)
    func didSelectSection(_ sectionIndex: Int)
}

final class FavoritesPresenter {
    var view: FavoritesViewProtocol?
    var interactor: FavoritesInteractorIntputProtocol?
    var router: FavoritesRouterProtocol?
    
    private var favoriteSection: FavoritesView.FavoriteSection = .song
    private var songs = [MediaModel]()
    private var albums = [MediaModel]()
}

// MARK: - FavoritesPresenterProtocol

extension FavoritesPresenter: FavoritesPresenterProtocol {
    
    func viewDidLoad() {
        interactor?.loadFavoriteSection()
    }
    
    func viewWillAppear() {
        interactor?.loadMedia()
    }

    func mediaCount() -> Int {
        switch favoriteSection {
        case .song:
            return songs.count
            
        case .album:
            return albums.count
        }
    }
    
    func metdiaItem(forIndexPath indexPath: IndexPath) -> MediaItem? {
        let mediaModel: MediaModel?
        
        switch favoriteSection {
        case .song:
            mediaModel = songs[indexPath.row]

        case .album:
            mediaModel = albums[indexPath.row]
        }
        
        guard let mediaModel else { return nil }
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
    
    func tapOnMediaItem(forIndexPath indexPath: IndexPath) {
        guard let mediaModel = getMediaModel(forIndexPath: indexPath) else { return }
        
        router?.presentDetailSongScreen(fromView: view, mediaModel: mediaModel)
    }
    
    func removeMediaItem(forIndexPath indexPath: IndexPath) {
        guard let mediaModel = getMediaModel(forIndexPath: indexPath) else { return }
        
        interactor?.removeMedia(forIndexPath: indexPath, mediaModel)
    }
    
    func didSelectSection(_ sectionIndex: Int) {
        guard let section = FavoritesView.FavoriteSection(rawValue: sectionIndex) else { return }

        favoriteSection = section
        
        isEmptySection(favoriteSection)
        view?.reloadData()
    }
    
}

// MARK: - FavoritesInteractorOutputProtocol

extension FavoritesPresenter: FavoritesInteractorOutputProtocol {
    
    func didLoadMedia(_ songs: [MediaModel], _ albums: [MediaModel]) {
        self.songs.removeAll()
        self.albums.removeAll()
        
        self.songs = songs
        self.albums = albums
        
        isEmptySection(favoriteSection)
        view?.reloadData()
    }
    
    func didRemoveMedia(forIndexPath indexPath: IndexPath, error: DBError?) {
        guard error == nil else {
            view?.showError(error!)
            return
        }
        
        let row = indexPath.row

        switch favoriteSection {
        case .song:
            songs.remove(at: row)

        case .album:
            albums.remove(at: row)
        }
        
        isEmptySection(favoriteSection)
        reloadData(forIndexPath: indexPath)
    }
    
    func didLoadFavoriteSection(_ sectionIndex: Int) {
        guard let section = FavoritesView.FavoriteSection(rawValue: sectionIndex) else { return }
        
        favoriteSection = section
        view?.setupFavoriteSection(sectionIndex)
    }
    
}

// MARK: - Private Methods

private extension FavoritesPresenter {
    
    func getMediaModel(forIndexPath indexPath: IndexPath) -> MediaModel? {
        var mediaModel: MediaModel?
        let row = indexPath.row
        
        switch favoriteSection {
        case .song:
            mediaModel = songs[row]
            
        case .album:
            mediaModel = albums[row]
        }
        
        return mediaModel
    }
    
    func reloadData(forIndexPath indexPath: IndexPath) {
        guard let section = FavoritesView.FavoriteSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .song:
            if songs.isEmpty {
                view?.reloadData()
                return
            }
            
        case .album:
            if albums.isEmpty {
                view?.reloadData()
                return
            }
        }
        
        view?.deleteRow(forIndexPath: indexPath)
    }
    
    func isEmptySection(_ favoriteSection: FavoritesView.FavoriteSection) {
        let isEmpty: Bool
        
        switch favoriteSection {
        case .song:
            isEmpty = songs.count == 0
            
        case .album:
            isEmpty = albums.count == 0
        }
        
        view?.setEmptyInfoText(favoriteSection.emptyText)
        view?.displayEmptyInfo(isEmpty)
    }
    
}
