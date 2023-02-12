//
//  OnboardingRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.01.2023.
//

import UIKit

protocol OnboardingRouterProtocol {
    static func createModule() -> UIViewController
    
    func presentSignInScreen(in viewController: OnboardingViewProtocol?)
}

final class OnboardingRouter: OnboardingRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view: OnboardingViewProtocol = OnboardingView()
        let presenter: OnboardingPresenterProtocol & OnboardingInteractorOutputProtocol = OnboardingPresenter()
        var interactor: OnboardingInteractorIntputProtocol = OnboardingInteractor()
        let router = OnboardingRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view.viewController
    }
    
    func presentSignInScreen(in viewController: OnboardingViewProtocol?) {
        let signInView = SignInRouter.createModule()
        viewController?.viewController.present(signInView, animated: true)
    }
    
}
