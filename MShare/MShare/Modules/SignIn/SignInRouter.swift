//
//  SignInRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 05.02.2023.
//

import UIKit
import SafariServices

protocol SignInRouterProtocol {
    func loadMain()
    func presentSafari(for view: SignInViewProtocol?, url: URL)
}

final class SignInRouter: Router, SignInRouterProtocol {
    override func createModule() -> UIViewController {
        let userManager = dependencyManager.resolve(type: UserManagerProtocol.self)
        
        let view: SignInViewProtocol = SignInView()
        let presenter: SignInPresenterProtocol & SignInInteractorOutputProtocol = SignInPresenter(view: view, router: self)
        let interactor: SignInInteractorIntputProtocol = SignInInteractor(presenter: presenter, userManager: userManager)
        
        view.presenter = presenter
        presenter.interactor = interactor
        return view.viewController
    }
    
    func loadMain() {
        let mainView = MainRouter(dependencyManager: dependencyManager).initMainModule()
        mainView.selectTab(.link)
        
        UIApplication.load(vc: mainView.viewController, backgroundColor: .systemBackground)
    }
    
    func presentSafari(for view: SignInViewProtocol?, url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        
        view?.viewController.present(safariViewController, animated: true)
    }
}
