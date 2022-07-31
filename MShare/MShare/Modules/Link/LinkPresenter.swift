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
    func getServices()
}

final class LinkPresenter {
    internal var view: LinkViewProtocol?
    internal var interactor: LinkInteractorIntputProtocol?
    internal var router: LinkRouterProtocol?
}

// MARK: - LinkPresenterProtocol

extension LinkPresenter: LinkPresenterProtocol {
    
    func viewDidAppear() {
        interactor?.setupNotification()
    }
    
    func getServices() {
        interactor?.requestServices()
    }
    
}

// MARK: - LinkInteractorOutputProtocol

extension LinkPresenter: LinkInteractorOutputProtocol {
    
    func didCatchURL(_ urlString: String) {
        view?.setLink(urlString)
    }
    
    func didFetchServices(_ serviceEntities: [ServiceEntity]) {
        let serviceItem: [ServiceItem] = serviceEntities.map { .init(title: $0.name, imageURL: "") }
        
        view?.setServiceItems(serviceItem)
    }
    
}
