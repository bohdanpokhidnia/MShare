//
//  MakeCoverRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 02.04.2023.
//

import UIKit

protocol MakeCoverRouterProtocol {
    
}

final class MakeCoverRouter: Router, MakeCoverRouterProtocol {
    
    // MARK: - Initializers
    
    init(
        dependencyManager: DependencyManagerProtocol,
        mediaResponse: MediaResponse,
        cover: UIImage?
    ) {
        self.mediaResponse = mediaResponse
        self.cover = cover
        
        super.init(dependencyManager: dependencyManager)
    }
    
    // MARK: - Override methods
    
    override func createModule() -> UIViewController {
        let factory = dependencyManager.resolve(type: FactoryProtocol.self)
        
        let view: MakeCoverViewProtocol = MakeCoverView()
        let presenter: MakeCoverPresenterProtocol & MakeCoverInteractorOutputProtocol = MakeCoverPresenter(view: view, router: self)
        let interactor: MakeCoverInteractorIntputProtocol = MakeCoverInteractor(
            presenter: presenter,
            factory: factory,
            mediaResponse: mediaResponse,
            cover: cover
        )
        
        view.presenter = presenter
        presenter.interactor = interactor
        return view.viewController
    }
    
    // MARK: - Private
    
    private let mediaResponse: MediaResponse
    private let cover: UIImage?
    
}
