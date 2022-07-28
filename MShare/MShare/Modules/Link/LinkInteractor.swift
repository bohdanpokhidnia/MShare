//
//  LinkInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import Foundation

protocol LinkInteractorIntputProtocol {
    var presenter: LinkInteractorOutputProtocol? { get set }
}

protocol LinkInteractorOutputProtocol: AnyObject {
    
}

final class LinkInteractor {
    weak var presenter: LinkInteractorOutputProtocol?
}

// MARK: - LinkInteractorInputProtocol

extension LinkInteractor: LinkInteractorIntputProtocol {
    
}
