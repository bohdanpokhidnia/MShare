//
//  ChartRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 08.08.2022.
//

import UIKit

protocol ChartRouterProtocol { }

final class ChartRouter: Router, ChartRouterProtocol {
    
    override func createModule() -> UIViewController {
        let view: ChartViewProtocol = ChartView()
        let presenter: ChartPresenterProtocol & ChartInteractorOutputProtocol = ChartPresenter()
        var interactor: ChartInteractorIntputProtocol = ChartInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = self
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        return navigationController
    }
    
}
