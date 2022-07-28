//
//  MainPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    var view: MainViewProtocol? { get set }
    var interactor: MainInteractorIntputProtocol? { get set }
    var router: MainRouterProtocol? { get set }
}

final class MainPresenter {
    var view: MainViewProtocol?
    var interactor: MainInteractorIntputProtocol?
    var router: MainRouterProtocol?
}

// MARK: - MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    
}

// MARK: - MainInteractorOutputProtocol

extension MainPresenter: MainInteractorOutputProtocol {
    
}
