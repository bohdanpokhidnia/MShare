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
    func removeNotifications()
    func requestSong(urlString: String)
}

protocol LinkInteractorOutputProtocol: AnyObject {
    func didCatchURL(_ urlString: String)
    func didCatchStringFromBuffer(_ stringFromBuffer: String)
    func didShowKeyboard(_ keyboardFrame: NSValue)
    func didHideKeyboard(_ keyboardFrame: NSValue)
    func didFetchSong(_ detailSong: DetailSongEntity)
    func didCatchError(_ error: NetworkError)
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
    func keyboardWillShow(notification: NSNotification) {
        guard let string = UIPasteboard.general.string else { return }
        presenter?.didCatchStringFromBuffer(string)
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        presenter?.didShowKeyboard(keyboardFrame)
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        presenter?.didHideKeyboard(keyboardFrame)
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func requestSong(urlString: String) {
        let group = DispatchGroup()
        var song: Song?
        
        group.enter()
        networkService.request(endpoint: GetSong(byUrl: urlString)) { [weak self] (response: Song?, error) in
                guard error == nil else {
                    self?.presenter?.didCatchError(error!)
                    group.leave()
                    return
                }
                
                guard let songResponse = response else {
                    group.leave()
                    return
                }
            
            song = songResponse
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let song else { return }
            
            self?.networkService.request(urlString: song.coverImageUrl) { (imageData, error) in
                guard error == nil else {
                    self?.presenter?.didCatchError(.error(error!))
                    return
                }
                
                guard let imageData,
                      let cover = UIImage(data: imageData) else {
                    self?.presenter?.didCatchError(.message("bad cover url \(song.coverImageUrl)"))
                    return
                }
                
                let detailSong = DetailSongEntity(songName: song.songName,
                                                  artistName: song.artistName,
                                                  image: cover,
                                                  sourceURL: song.songUrl)
                
                DispatchQueue.main.async {
                    self?.presenter?.didFetchSong(detailSong)
                }
            }
        }
    }
    
}
