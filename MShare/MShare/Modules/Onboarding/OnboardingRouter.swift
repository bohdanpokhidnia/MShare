//
//  OnboardingRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.01.2023.
//

import UIKit

protocol OnboardingRouterProtocol {
    func loadMain()
    func presentSignInScreen(in viewController: OnboardingViewProtocol?)
}

final class OnboardingRouter: Router {
    override func createModule() -> UIViewController {
        let userManager = dependencyManager.resolve(type: UserManagerProtocol.self)
        
        let view: OnboardingViewProtocol = OnboardingView()
        let presenter: OnboardingPresenterProtocol & OnboardingInteractorOutputProtocol = OnboardingPresenter(view: view, router: self)
        let interactor: OnboardingInteractorIntputProtocol = OnboardingInteractor(
            presenter: presenter,
            userManager: userManager
        )
        
        view.presenter = presenter
        presenter.interactor = interactor
        return view.viewController
    }
}

//MARK: - OnboardingRouterProtocol

extension OnboardingRouter: OnboardingRouterProtocol {
    func loadMain() {
        appRouter?.loadMain()
    }
    
    func presentSignInScreen(in viewController: OnboardingViewProtocol?) {
        let signInView = SignInRouter(dependencyManager: dependencyManager).createModule()
        viewController?.viewController.present(signInView, animated: true)
    }
}
