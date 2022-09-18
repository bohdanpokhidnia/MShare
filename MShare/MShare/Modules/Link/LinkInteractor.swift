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
    
    // MARK: - Initializers
    
    init() {
        networkService = NetworkService()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    
    private var services = [ServiceEntity]()
    private let networkService: NetworkServiceProtocol
    
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
        networkService.request(endpoint: GetSong(byUrl: urlString)) { [weak presenter] (response: Song?, error) in
            guard error == nil else {
                print("[dev] \(error!)")
                return
            }
            
            guard let song = response else { return }
            
            let detailSong = DetailSongEntity(songName: song.songName,
                                              artistName: song.artistName,
                                              coverURL: song.coverImageUrl,
                                              sourceURL: song.songUrl)
            
            DispatchQueue.main.async {
                presenter?.didFetchSong(detailSong)
            }
        }
    }
    
}
