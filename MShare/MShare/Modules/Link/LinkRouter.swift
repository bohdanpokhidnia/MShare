//
//  LinkRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol LinkRouterProtocol {
    static func createModule() -> UIViewController
    
    func pushSongListScreen(from view: LinkViewProtocol, for songList: [SongListEntity])
}

class LinkRouter: LinkRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view: LinkViewProtocol = LinkView()
        let presenter: LinkPresenterProtocol & LinkInteractorOutputProtocol = LinkPresenter()
        var interactor: LinkInteractorIntputProtocol = LinkInteractor()
        let router = LinkRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        return navigationController
    }
    
    func pushSongListScreen(from view: LinkViewProtocol, for songList: [SongListEntity]) {
        let songListModule = SongListRouter.createModule(songList)
        view.viewController.navigationController?.pushViewController(songListModule, animated: true)
    }
    
}
