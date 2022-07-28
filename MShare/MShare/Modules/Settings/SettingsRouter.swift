//
//  SettingsRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol SettingsRouterProtocol {
    static func createModule() -> UIViewController
}

class SettingsRouter: SettingsRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view: SettingsViewProtocol = SettingsView()
        let presenter: SettingsPresenterProtocol & SettingsInteractorOutputProtocol = SettingsPresenter()
        var interactor: SettingsInteractorIntputProtocol = SettingsInteractor()
        let router = SettingsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: view.viewController)
        return navigationController
    }
    
}
