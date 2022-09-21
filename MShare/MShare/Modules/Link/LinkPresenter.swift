//
//  LinkPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import Foundation

protocol LinkPresenterProtocol: AnyObject {
    var view: LinkViewProtocol? { get set }
    var interactor: LinkInteractorIntputProtocol? { get set }
    var router: LinkRouterProtocol? { get set }
    
    func viewDidAppear()
    func pasteTextFromBuffer()
    func getSong(urlString: String)
}

final class LinkPresenter {
    var view: LinkViewProtocol?
    var interactor: LinkInteractorIntputProtocol?
    var router: LinkRouterProtocol?
    
    private var stringFromBuffer: String?
}

// MARK: - LinkPresenterProtocol

extension LinkPresenter: LinkPresenterProtocol {
    
    func viewDidAppear() {
        interactor?.setupNotifications()
    }
    
    func pasteTextFromBuffer() {
        guard let stringFromBuffer = stringFromBuffer else { return }
        
        view?.setLink(stringFromBuffer)
        self.stringFromBuffer = nil
        view?.hideSetLink(true)
    }
    
    func getSong(urlString: String) {
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
    
    func didFetchSong(_ detailSong: DetailSongEntity) {
        router?.presentDetailSongScreen(from: view, for: detailSong)
    }
    
    func didCatchError(_ error: NetworkError) {
        view?.showError(title: error.title, message: error.localizedDescription)
    }
    
}
