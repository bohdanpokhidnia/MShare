//
//  MainInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import Foundation

protocol MainInteractorIntputProtocol {
    var presenter: MainInteractorOutputProtocol? { get set }
}

protocol MainInteractorOutputProtocol: AnyObject {
    
}

final class MainInteractor {
    weak var presenter: MainInteractorOutputProtocol?
}

// MARK: - MainInteractorInputProtocol

extension MainInteractor: MainInteractorIntputProtocol {
    
}
