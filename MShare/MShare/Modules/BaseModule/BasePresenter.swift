//
//  BasePresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 07.10.2023.
//

import Foundation

class BasePresenter: BaseInteractorOutputProtocol {
    weak var baseView: BaseView?
    
    init(baseView: BaseView?) {
        self.baseView = baseView
    }
    
    func handleNetworkError(error: BaseError) {
        baseView?.handleNetworkError(error: error)
    }
}
