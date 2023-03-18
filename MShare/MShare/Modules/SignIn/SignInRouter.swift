//
//  SignInRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 05.02.2023.
//

import UIKit
import SafariServices

protocol SignInRouterProtocol {
    func showMain()
    func presentBrowserScreen(from view: SignInViewProtocol?, forUrlString urlString: String)
}

final class SignInRouter: Router, SignInRouterProtocol {
    
    override func createModule() -> UIViewController {
        let userManager = dependencyManager.resolve(type: UserManagerProtocol.self)
        
        let view: SignInViewProtocol = SignInView()
        let presenter: SignInPresenterProtocol & SignInInteractorOutputProtocol = SignInPresenter()
        var interactor: SignInInteractorIntputProtocol = SignInInteractor(userManager: userManager)
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = self
        interactor.presenter = presenter
        
        return view.viewController
    }
    
    func showMain() {
        let mainView = MainRouter(dependencyManager: dependencyManager).initMainModule()
        mainView.selectedTab(.link)
        
        UIApplication.load(vc: mainView.viewController, backgroundColor: .systemBackground)
    }
    
    func presentBrowserScreen(from view: SignInViewProtocol?, forUrlString urlString: String) {
        let safariViewController = SFSafariViewController(url: URL(string: urlString)!)
        
        view?.viewController.present(safariViewController, animated: true)
    }
    
}
