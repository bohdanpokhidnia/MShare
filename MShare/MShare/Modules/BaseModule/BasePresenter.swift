//
//  BasePresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 07.10.2023.
//

import Foundation

class BasePresenter: BaseInteractorOutputProtocol {
    var baseView: BaseModuleView?
    
    init(baseView: BaseModuleView?) {
        self.baseView = baseView
    }
    
    func handleNetworkError(error: BaseError) {
        baseView?.handleNetworkError(error: error)
    }
}
