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
    
}
