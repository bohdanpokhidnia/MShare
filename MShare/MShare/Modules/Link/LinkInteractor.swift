//
//  LinkInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol LinkInteractorIntputProtocol {
    var presenter: LinkInteractorOutputProtocol? { get set }
    
    func setupNotification()
}

protocol LinkInteractorOutputProtocol: AnyObject {
    func didCatchURL(_ urlString: String)
}

final class LinkInteractor {
    
    weak var presenter: LinkInteractorOutputProtocol?
    
    init() {
        
    }
    
    @objc
    func handleURL() {
        guard let incomingURL = UserDefaults().value(forKey: "incomingURL") as? String else { return }
    
        presenter?.didCatchURL(incomingURL)
        UserDefaults().removeObject(forKey: "incomingURL")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - LinkInteractorInputProtocol

extension LinkInteractor: LinkInteractorIntputProtocol {
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleURL),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
}
