//
//  MakeCoverPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 02.04.2023.
//

import Foundation

protocol MakeCoverPresenterProtocol: AnyObject {
    var view: MakeCoverViewProtocol? { get set }
    var interactor: MakeCoverInteractorIntputProtocol? { get set }
    var router: MakeCoverRouterProtocol? { get set }
    
    func viewDidLoad()
}

final class MakeCoverPresenter {
    weak var view: MakeCoverViewProtocol?
    var interactor: MakeCoverInteractorIntputProtocol?
    var router: MakeCoverRouterProtocol?
    
    // MARK: - Initializers
    
    init(view: MakeCoverViewProtocol?, router: MakeCoverRouterProtocol?) {
        self.view = view
        self.router = router
    }
}

// MARK: - MakeCoverPresenterProtocol

extension MakeCoverPresenter: MakeCoverPresenterProtocol {
    func viewDidLoad() {
        interactor?.requestData()
    }
}

// MARK: - MakeCoverInteractorOutputProtocol

extension MakeCoverPresenter: MakeCoverInteractorOutputProtocol {
    func didLoadData(entity: SongDetailsEntity) {
        view?.setupContent(from: entity)
    }
}
