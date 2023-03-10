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
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    
    private let apiClient: ApiClient
    
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
        Task {
            let result = await apiClient.request(endpoint: GetSong(url: urlString), response: MediaResponse.self)
            
            switch result {
            case .success(let response):
                guard let coverUrlString = response.coverUrlString else { return }
                let (data, error) = await apiClient.request(urlString: coverUrlString)
                
                guard let data, error == nil
                else {
                    presenter?.didCatchError(error!)
                    return
                }
                
                let cover = UIImage(data: data)
                
                DispatchQueue.main.async { [weak presenter] in
                    presenter?.didFetchMedia(mediaResponse: response, cover: cover)
                }
            case .failure(let error):
                presenter?.didCatchError(.error(error))
            }
        }
    }
    
    func copyImageToBuffer(_ image: UIImage) {
        UIPasteboard.general.image = image
    }
    
}
