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
    func showSongList(at indexPath: IndexPath)
}

final class LinkPresenter {
    var view: LinkViewProtocol?
    var interactor: LinkInteractorIntputProtocol?
    var router: LinkRouterProtocol?
    
    private var services = [ServiceEntity]()
}

// MARK: - LinkPresenterProtocol

extension LinkPresenter: LinkPresenterProtocol {
    
    func viewDidAppear() {
        interactor?.setupNotification()
    }
    
    func numberOfRows() -> Int {
        return services.count
    }
    
    func itemForRow(at indexPath: IndexPath) -> MediaItem {
        let service = services[indexPath.row]
        
        return .init(tiile: service.name, defaultPlaceholder: service.imageLogo)
    }
    
    func getServices() {
        interactor?.requestServices()
    }
    
    func showSongList(at indexPath: IndexPath) {
        guard let view = view else { return }
        let service = services[indexPath.row]
        
        router?.pushSongListScreen(from: view, for: [.mock])
    }
    
}

// MARK: - LinkInteractorOutputProtocol

extension LinkPresenter: LinkInteractorOutputProtocol {
    
    func didCatchURL(_ urlString: String) {
        view?.setLink(urlString)
        
        interactor?.requestServices()
    }
    
    func didFetchServices(_ serviceEntities: [ServiceEntity]) {
        services.removeAll()
        services = serviceEntities
        
        view?.reloadData()
    }
    
}
