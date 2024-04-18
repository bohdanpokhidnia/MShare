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

protocol LinkInteractorOutputProtocol: BaseInteractorOutputProtocol {
    func didCatchURL(_ urlString: String)
    func didCatchFromBuffer(string: String)
    func didShowKeyboard(_ keyboardFrame: NSValue)
    func didHideKeyboard(_ keyboardFrame: NSValue)
    func didFetchMedia(mediaResponse: MediaResponse, cover: UIImage?)
}

final class LinkInteractor: BaseInteractor {
    weak var presenter: LinkInteractorOutputProtocol?
    
    // MARK: - Initializers
    
    init(
        presenter: LinkInteractorOutputProtocol,
        apiClient: HttpClient
    ) {
        self.presenter = presenter
        self.apiClient = apiClient
        
        super.init(basePresenter: presenter)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    
    private let apiClient: HttpClient
}

// MARK: - User interactions

private extension LinkInteractor {
    @objc
    func handleURL() {
        guard let incomingURL = UserDefaults().value(forKey: "incomingURL") as? String else {
            return
        }
    
        presenter?.didCatchURL(incomingURL)
        UserDefaults().removeObject(forKey: "incomingURL")
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { 
            return
        }
        
        presenter?.didShowKeyboard(keyboardFrame)
        
        guard let string = UIPasteboard.general.string else {
            return
        }
        
        presenter?.didCatchFromBuffer(string: string)
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { 
            return
        }
        
        presenter?.didHideKeyboard(keyboardFrame)
    }
}

// MARK: - LinkInteractorInputProtocol

extension LinkInteractor: LinkInteractorIntputProtocol {
    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleURL),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func requestSong(urlString: String) {
        Task { @MainActor in
            do {
                let mediaResponse = try await apiClient.request(endpoint: GetSong(url: urlString), response: MediaResponse.self)
                let coverData = try await apiClient.request(urlString: mediaResponse.coverUrlString)
                let coverImage = UIImage(data: coverData)
                
                presenter?.didFetchMedia(mediaResponse: mediaResponse, cover: coverImage)
            } catch let networkError as NetworkError {
                presenter?.handleNetworkError(error: networkError)
            } catch {
                presenter?.handleNetworkError(error: NetworkError.error(error))
            }
        }
    }
}
