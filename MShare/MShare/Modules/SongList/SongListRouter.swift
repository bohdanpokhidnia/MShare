//
//  SongListRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 04.08.2022.
//

import UIKit

protocol SongListRouterProtocol {
    static func createModule(_ songList: [SongListEntity]) -> UIViewController
}

class SongListRouter: SongListRouterProtocol {
    
    static func createModule(_ songList: [SongListEntity]) -> UIViewController {
        let presenter: SongListPresenterProtocol & SongListInteractorOutputProtocol = SongListPresenter()
        let view: SongListViewProtocol = SongListView(presenter: presenter)
        var interactor: SongListInteractorIntputProtocol = SongListInteractor(songList: songList)
        let router = SongListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view.viewController
    }
    
}
