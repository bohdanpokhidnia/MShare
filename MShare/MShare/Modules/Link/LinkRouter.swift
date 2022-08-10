//
//  LinkRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol LinkRouterProtocol {
    static func createModule() -> UIViewController
    
    func presentShareLinkView(from view: LinkViewProtocol?, shareLinkView: UIActivityViewController)
    func pushDetailSongScreen(from view: LinkViewProtocol?, for song: DetailSongEntity)
}

class LinkRouter: LinkRouterProtocol {
    
    static func createModule() -> UIViewController {
        let presenter: LinkPresenterProtocol & LinkInteractorOutputProtocol = LinkPresenter()
        let view: LinkViewProtocol = LinkView(presenter: presenter)
        var interactor: LinkInteractorIntputProtocol = LinkInteractor()
        let router = LinkRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        return navigationController
    }
    
    func presentShareLinkView(from view: LinkViewProtocol?, shareLinkView: UIActivityViewController) {
        view?.viewController.present(shareLinkView, animated: true)
    }
    
    func pushDetailSongScreen(from view: LinkViewProtocol?, for song: DetailSongEntity) {
        let detailSongScreen = DetailSongRouter.createModule(song: song)
        detailSongScreen.hidesBottomBarWhenPushed = true
        
        view?.viewController.navigationController?.pushViewController(detailSongScreen, animated: true)
    }
    
}
