//
//  OnboardingRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.01.2023.
//

import UIKit

protocol OnboardingRouterProtocol {
    func presentSignInScreen(in viewController: OnboardingViewProtocol?)
}

final class OnboardingRouter: Router, OnboardingRouterProtocol {
    
    override func createModule() -> UIViewController {
        let view: OnboardingViewProtocol = OnboardingView()
        let presenter: OnboardingPresenterProtocol & OnboardingInteractorOutputProtocol = OnboardingPresenter()
        var interactor: OnboardingInteractorIntputProtocol = OnboardingInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = self
        interactor.presenter = presenter
        
        return view.viewController
    }
    
    func presentSignInScreen(in viewController: OnboardingViewProtocol?) {
        let signInView = SignInRouter(dependencyManager: dependencyManager).createModule()
        viewController?.viewController.present(signInView, animated: true)
    }
    
}
