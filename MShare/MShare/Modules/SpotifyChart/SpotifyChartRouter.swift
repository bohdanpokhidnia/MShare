//
//  SpotifyChartRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

protocol SpotifyChartRouterProtocol {
    static func createModule() -> UIViewController
}

class SpotifyChartRouter: SpotifyChartRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view: SpotifyChartViewProtocol = SpotifyChartView()
        let presenter: SpotifyChartPresenterProtocol & SpotifyChartInteractorOutputProtocol = SpotifyChartPresenter()
        var interactor: SpotifyChartInteractorIntputProtocol = SpotifyChartInteractor()
        let router = SpotifyChartRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        return navigationController
    }
    
}
