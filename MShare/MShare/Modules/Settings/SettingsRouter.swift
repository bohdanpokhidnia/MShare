//
//  SettingsRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit
import SafariServices

protocol SettingsRouterProtocol: ModuleRouterProtocol {
    func presentBrowserScreen(from view: SettingsViewProtocol, forUrlString urlString: String)
}

final class SettingsRouter: SettingsRouterProtocol {
    
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
    
    func createModule() -> UIViewController {
        return SettingsRouter.createModule()
    }
    
    func presentBrowserScreen(from view: SettingsViewProtocol, forUrlString urlString: String) {
        let safariViewController = SFSafariViewController(url: URL(string: urlString)!)
        
        view.viewController.present(safariViewController, animated: true)
    }
    
}
