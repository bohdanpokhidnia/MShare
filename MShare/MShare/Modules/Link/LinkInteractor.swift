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
    func requestSong(urlString: String)
}

protocol LinkInteractorOutputProtocol: AnyObject {
    func didCatchURL(_ urlString: String)
    func didFetchSong(_ detailSong: DetailSongEntity)
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
    
    func requestSong(urlString: String) {
        let song = DetailSongEntity.mock
        
        presenter?.didFetchSong(song)
    }
    
}
