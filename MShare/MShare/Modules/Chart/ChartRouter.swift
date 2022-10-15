//
//  ChartRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 08.08.2022.
//

import UIKit

protocol ChartRouterProtocol: ModuleRouterProtocol { }

final class ChartRouter: ChartRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view: ChartViewProtocol = ChartView()
        let presenter: ChartPresenterProtocol & ChartInteractorOutputProtocol = ChartPresenter()
        var interactor: ChartInteractorIntputProtocol = ChartInteractor()
        let router = ChartRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        return navigationController
    }
    
    func createModule() -> UIViewController {
        return ChartRouter.createModule()
    }
    
}
