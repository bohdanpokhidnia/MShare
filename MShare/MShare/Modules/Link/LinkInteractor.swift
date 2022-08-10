//
//  LinkInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol LinkInteractorIntputProtocol {
    var presenter: LinkInteractorOutputProtocol? { get set }
    
    func setupNotification()
    func requestServices()
    func giveSourceURL(at indexPath: IndexPath)
    func makeShareLinkView(_ sourceURL: String) -> UIActivityViewController
    func giveSong(at indexPath: IndexPath)
}

protocol LinkInteractorOutputProtocol: AnyObject {
    func didCatchURL(_ urlString: String)
    func didFetchServices(_ serviceEntities: [ServiceEntity])
    func takeSourceURL(_ sourceURL: String)
    func takeSong(_ song: DetailSongEntity)
}

final class LinkInteractor {
    
    weak var presenter: LinkInteractorOutputProtocol?
    
    @objc
    func handleURL() {
        guard let incomingURL = UserDefaults().value(forKey: "incomingURL") as? String else { return }
    
        presenter?.didCatchURL(incomingURL)
        UserDefaults().removeObject(forKey: "incomingURL")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var services = [ServiceEntity]()
    
}

// MARK: - Private Methods

private extension LinkInteractor {
    
    func getSong(by indexPath: IndexPath) -> DetailSongEntity {
        let service = services[indexPath.section]
        let song = service.songs[indexPath.row]
        
        return song
    }
    
}

// MARK: - LinkInteractorInputProtocol

extension LinkInteractor: LinkInteractorIntputProtocol {
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleURL),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    func requestServices() {
        services.removeAll()
        services = [.mock]
        
        presenter?.didFetchServices(services)
    }
    
    func giveSourceURL(at indexPath: IndexPath) {
        let song = getSong(by: indexPath)
        let sourceURL = song.sourceURL
        
        presenter?.takeSourceURL(sourceURL)
    }
    
    func makeShareLinkView(_ sourceURL: String) -> UIActivityViewController {
        let items = [sourceURL]
        
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func giveSong(at indexPath: IndexPath) {
        let song = getSong(by: indexPath)
        
        presenter?.takeSong(song)
    }
    
}
