//
//  LinkPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import Foundation

protocol LinkPresenterProtocol: AnyObject {
    var view: LinkViewProtocol? { get set }
    var interactor: LinkInteractorIntputProtocol? { get set }
    var router: LinkRouterProtocol? { get set }
    
    func viewDidAppear()
    func numberOfRows() -> Int
    func itemForRow(at indexPath: IndexPath) -> MediaItem
    func getServices()
    func getShareLink(at indexPath: IndexPath)
    func didTapSong(at indexPath: IndexPath)
}

final class LinkPresenter {
    var view: LinkViewProtocol?
    var interactor: LinkInteractorIntputProtocol?
    var router: LinkRouterProtocol?
    
    private var songs = [MediaItem]()
}

// MARK: - LinkPresenterProtocol

extension LinkPresenter: LinkPresenterProtocol {
    
    func viewDidAppear() {
        interactor?.setupNotification()
    }
    
    func numberOfRows() -> Int {
        return songs.count
    }
    
    func itemForRow(at indexPath: IndexPath) -> MediaItem {
        let song = songs[indexPath.row]
        return song
    }
    
    func getServices() {
        interactor?.requestServices()
    }
    
    func getShareLink(at indexPath: IndexPath) {
        interactor?.giveSourceURL(at: indexPath)
    }
    
    func didTapSong(at indexPath: IndexPath) {
        interactor?.giveSong(at: indexPath)
    }
    
}

// MARK: - LinkInteractorOutputProtocol

extension LinkPresenter: LinkInteractorOutputProtocol {
    
    func didCatchURL(_ urlString: String) {
        view?.setLink(urlString)
        
        interactor?.requestServices()
    }
    
    func didFetchServices(_ serviceEntities: [ServiceEntity]) {
        songs.removeAll()
        
        for serviceEntity in serviceEntities {
            view?.setHeaderTitle(serviceEntity.name)
            
            songs.append(contentsOf: serviceEntity.songs.map { .init(tiile: $0.songName,
                                                                     subtitle: $0.artistName,
                                                                     imageURL: $0.coverURL,
                                                                     displayShareButton: true) })
        }
        
        view?.reloadData()
    }
    
    func takeSourceURL(_ sourceURL: String) {
        guard let shareLinkView = interactor?.makeShareLinkView(sourceURL) else { return }
        
        router?.presentShareLinkView(from: view, shareLinkView: shareLinkView)
    }
    
    func takeSong(_ song: DetailSongEntity) {
        router?.pushDetailSongScreen(from: view, for: song)
    }
    
}
