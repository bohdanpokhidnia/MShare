//
//  BaseInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 07.10.2023.
//

import Foundation

class BaseInteractor: NetworkErrorHandling {
    weak var basePresenter: BaseInteractorOutputProtocol?
    
    init(basePresenter: BaseInteractorOutputProtocol?) {
        self.basePresenter = basePresenter
    }
    
    func handleNetworkError(error: BaseError) {
        basePresenter?.handleNetworkError(error: error)
    }
}

protocol BaseInteractorOutputProtocol: AnyObject, NetworkErrorHandling {
    
}
