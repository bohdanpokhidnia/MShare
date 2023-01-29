//
//  OnboardingRouter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.01.2023.
//

import UIKit

protocol OnboardingRouterProtocol {
    static func createModule() -> UIViewController
    
    func showMain()
}

final class OnboardingRouter: OnboardingRouterProtocol {
    
    static func createModule() -> UIViewController {
        @Inject var userManager: UserManagerProtocol
        
        let view: OnboardingViewProtocol = OnboardingView()
        let presenter: OnboardingPresenterProtocol & OnboardingInteractorOutputProtocol = OnboardingPresenter()
        var interactor: OnboardingInteractorIntputProtocol = OnboardingInteractor(userManager: userManager)
        let router = OnboardingRouter()
        
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
    
}
