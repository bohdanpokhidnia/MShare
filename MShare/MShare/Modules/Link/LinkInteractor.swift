//
//  LinkInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol LinkInteractorIntputProtocol {
    var presenter: LinkInteractorOutputProtocol? { get set }
    
    func setupNotifications()
    func requestSong(urlString: String)
}

protocol LinkInteractorOutputProtocol: AnyObject {
    func didCatchURL(_ urlString: String)
    func didCatchStringFromBuffer(_ stringFromBuffer: String)
    func didFetchSong(_ detailSong: DetailSongEntity)
}

final class LinkInteractor {
    
    weak var presenter: LinkInteractorOutputProtocol?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var services = [ServiceEntity]()
    
}

// MARK: - User interactions

private extension LinkInteractor {
    
    @objc
    func handleURL() {
        guard let incomingURL = UserDefaults().value(forKey: "incomingURL") as? String else { return }
    
        presenter?.didCatchURL(incomingURL)
        UserDefaults().removeObject(forKey: "incomingURL")
    }
    
    @objc
    func keyboardWillShow() {
        guard let string = UIPasteboard.general.string else { return }
        
        presenter?.didCatchStringFromBuffer(string)
    }
    
}

// MARK: - LinkInteractorInputProtocol

extension LinkInteractor: LinkInteractorIntputProtocol {
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleURL),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    func requestSong(urlString: String) {
        let song = DetailSongEntity.mock
        
        presenter?.didFetchSong(song)
    }
    
}
