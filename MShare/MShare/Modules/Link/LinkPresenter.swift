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
    
    func setupPresenter()
}

final class LinkPresenter {
    var view: LinkViewProtocol?
    var interactor: LinkInteractorIntputProtocol?
    var router: LinkRouterProtocol?
}

// MARK: - LinkPresenterProtocol

extension LinkPresenter: LinkPresenterProtocol {
    
    func setupPresenter() {
        interactor?.setupNotification()
    }
    
}

// MARK: - LinkInteractorOutputProtocol

extension LinkPresenter: LinkInteractorOutputProtocol {
    
    func didCatchURL(_ urlString: String) {
        view?.setLink(urlString)
    }
    
}
