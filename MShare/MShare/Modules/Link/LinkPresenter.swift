//
//  LinkPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol LinkPresenterProtocol: AnyObject {
    var view: LinkViewProtocol? { get set }
    var interactor: LinkInteractorIntputProtocol? { get set }
    var router: LinkRouterProtocol? { get set }
    
    func viewWillAppear()
    func viewWillDisappear()
    func pasteTextFromBuffer()
    func getSong(urlString: String)
}

final class LinkPresenter {
    weak var view: LinkViewProtocol?
    var interactor: LinkInteractorIntputProtocol?
    var router: LinkRouterProtocol?
    
    private var stringFromBuffer: String?
}

// MARK: - LinkPresenterProtocol

extension LinkPresenter: LinkPresenterProtocol {
    
    func viewWillAppear() {
        interactor?.setupNotifications()
    }
    
    func viewWillDisappear() {
        interactor?.removeNotifications()
    }
    
    func pasteTextFromBuffer() {
        guard let stringFromBuffer = stringFromBuffer else { return }
        
        view?.setLink(stringFromBuffer)
        self.stringFromBuffer = nil
        view?.hideSetLink(true)
    }
    
    func getSong(urlString: String) {
        view?.showLoading()
        
        interactor?.requestSong(urlString: urlString)
    }
    
}

// MARK: - LinkInteractorOutputProtocol

extension LinkPresenter: LinkInteractorOutputProtocol {
    
    func didCatchURL(_ urlString: String) {
        view?.setLink(urlString)
        
        interactor?.requestSong(urlString: urlString)
    }
    
    func didCatchStringFromBuffer(_ stringFromBuffer: String) {
        view?.hideSetLink(!stringFromBuffer.isValidURL)
        self.stringFromBuffer = stringFromBuffer
        view?.setLinkTitle(stringFromBuffer)
    }
    
    func didShowKeyboard(_ keyboardFrame: NSValue) {
        view?.setOffsetLinkTextField(keyboardFrame.cgRectValue)
    }
    
    func didHideKeyboard(_ keyboardFrame: NSValue) {
        view?.resetPositionLinkTextField()
    }
    
    func didFetchMedia(mediaResponse: MediaResponse, cover: UIImage?) {
        guard let cover else { return }
        
        router?.presentDetailSongScreen(from: view, mediaResponse: mediaResponse, cover: cover) { [weak view] in
            view?.cleaningLinkTextField()
            view?.hideLoading(completion: nil)
        }
    }
    
    func didCatchError(_ error: NetworkError) {
        DispatchQueue.main.async { [weak view] in
            view?.hideLoading() {
                view?.showError(title: error.title, message: error.localizedDescription, action: {
                    view?.resetLinkTextFieldBorderColor(animated: true)
                })
            }
        }
    }
    
}
