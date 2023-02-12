//
//  SignInRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 05.02.2023.
//

import UIKit
import SafariServices

protocol SignInRouterProtocol {
    static func createModule() -> UIViewController
    
    func showMain()
    func presentBrowserScreen(from view: SignInViewProtocol?, forUrlString urlString: String)
}

final class SignInRouter: SignInRouterProtocol {
    
    static func createModule() -> UIViewController {
        @Inject var userManager: UserManagerProtocol
        
        let view: SignInViewProtocol = SignInView()
        let presenter: SignInPresenterProtocol & SignInInteractorOutputProtocol = SignInPresenter()
        var interactor: SignInInteractorIntputProtocol = SignInInteractor(userManager: userManager)
        let router = SignInRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view.viewController
    }
    
    func showMain() {
        let mainView = MainRouter.createModule()
        mainView.selectedTab(.link)
        
        UIApplication.load(vc: mainView.viewController)
    }
    
    func presentBrowserScreen(from view: SignInViewProtocol?, forUrlString urlString: String) {
        let safariViewController = SFSafariViewController(url: URL(string: urlString)!)
        
        view?.viewController.present(safariViewController, animated: true)
    }
    
}
