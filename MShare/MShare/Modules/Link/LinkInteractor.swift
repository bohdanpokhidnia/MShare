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
    func copyImageToBuffer(_ image: UIImage)
}

protocol LinkInteractorOutputProtocol: AnyObject {
    func didCatchURL(_ urlString: String)
    func didCatchStringFromBuffer(_ stringFromBuffer: String)
    func didShowKeyboard(_ keyboardFrame: NSValue)
    func didHideKeyboard(_ keyboardFrame: NSValue)
    func didFetchMedia(mediaResponse: MediaResponse, cover: UIImage?)
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
        var mediaResponse: MediaResponse?
        
        group.enter()
        networkService.request(endpoint: GetSong(byUrl: urlString)) { [weak self] (response: MediaResponse?, error) in
                guard error == nil else {
                    self?.presenter?.didCatchError(error!)
                    group.leave()
                    return
                }
            
            mediaResponse = response
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let mediaResponse,
                  let coverUrlString = mediaResponse.coverUrlString
            else {
                print("[dev] without media response")
                return
            }
            
            self?.networkService.request(urlString: coverUrlString) { (imageData, error) in
                guard error == nil else { return }
                
                guard let imageData,
                      let cover = UIImage(data: imageData) else { return }
                
                DispatchQueue.main.async {
                    self?.presenter?.didFetchMedia(mediaResponse: mediaResponse, cover: cover)
                }
            }
        }
    }
    
    func copyImageToBuffer(_ image: UIImage) {
        UIPasteboard.general.image = image
    }
    
}
