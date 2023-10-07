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
    
    init(
        presenter: LinkInteractorOutputProtocol,
        apiClient: ApiClient
    ) {
        self.presenter = presenter
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
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        presenter?.didShowKeyboard(keyboardFrame)
        
        guard let string = UIPasteboard.general.string else { return }
        presenter?.didCatchStringFromBuffer(string)
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
        Task {
            do {
                let mediaResponse = try await apiClient.request(endpoint: GetSong(url: urlString), response: MediaResponse.self)
                let coverData = try await apiClient.request(urlString: mediaResponse.coverUrlString ?? "")
                let coverImage = UIImage(data: coverData)
                
                DispatchQueue.main.async { [weak presenter] in
                    presenter?.didFetchMedia(mediaResponse: mediaResponse, cover: coverImage)
                }
            } catch let networkError as NetworkError {
                presenter?.didCatchError(networkError)
            } catch {
                dprint(error, logType: .error)
            }
        }
    }
    
    func copyImageToBuffer(_ image: UIImage) {
        UIPasteboard.general.image = image
    }
    
}
