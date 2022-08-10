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
    func takeSourceURL(at indexPath: IndexPath)
    func makeShareLinkView(_ sourceURL: String) -> UIActivityViewController
}

protocol LinkInteractorOutputProtocol: AnyObject {
    func didCatchURL(_ urlString: String)
    func didFetchServices(_ serviceEntities: [ServiceEntity])
    func giveSourceURL(_ sourceURL: String)
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
    
    func takeSourceURL(at indexPath: IndexPath) {
        let songs = services[indexPath.section].songs
        let song = songs[indexPath.row]
        let sourceURL = song.sourceURL
        
        presenter?.giveSourceURL(sourceURL)
    }
    
    func makeShareLinkView(_ sourceURL: String) -> UIActivityViewController {
        let items = [sourceURL]
        
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
}
