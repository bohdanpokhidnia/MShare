//
//  AppleMusicChartRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

protocol AppleMusicChartRouterProtocol {
    static func createModule() -> UIViewController
}

class AppleMusicChartRouter: AppleMusicChartRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view: AppleMusicChartViewProtocol = AppleMusicChartView()
        let presenter: AppleMusicChartPresenterProtocol & AppleMusicChartInteractorOutputProtocol = AppleMusicChartPresenter()
        var interactor: AppleMusicChartInteractorIntputProtocol = AppleMusicChartInteractor()
        let router = AppleMusicChartRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        return navigationController
    }
    
}
