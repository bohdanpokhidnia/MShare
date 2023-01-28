//
//  OnboardingRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.01.2023.
//

import UIKit

protocol OnboardingRouterProtocol {
    static func createModule() -> UIViewController
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
    
}
