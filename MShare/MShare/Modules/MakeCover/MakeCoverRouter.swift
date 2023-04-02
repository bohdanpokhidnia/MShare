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
    
    private let mediaResponse: MediaResponse
    private let cover: UIImage?
    
    // MARK: - Initializers
    
    init(mediaResponse: MediaResponse, cover: UIImage?, dependencyManager: DependencyManagerProtocol) {
        self.mediaResponse = mediaResponse
        self.cover = cover
        
        super.init(dependencyManager: dependencyManager)
    }
    
    // MARK: - Override methods
    
    override func createModule() -> UIViewController {
        let view: MakeCoverViewProtocol = MakeCoverView()
        let presenter: MakeCoverPresenterProtocol & MakeCoverInteractorOutputProtocol = MakeCoverPresenter()
        var interactor: MakeCoverInteractorIntputProtocol = MakeCoverInteractor(
            mediaResponse: mediaResponse,
            cover: cover
        )
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = self
        interactor.presenter = presenter
        
        return view.viewController
    }
    
}
