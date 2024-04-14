//
//  OnboardingPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.01.2023.
//

import Foundation

protocol OnboardingPresenterProtocol: AnyObject {
    var view: OnboardingViewProtocol? { get set }
    var interactor: OnboardingInteractorIntputProtocol? { get set }
    var router: OnboardingRouterProtocol? { get set }
    
    func didTapLetsGo()
}

final class OnboardingPresenter {
    weak var view: OnboardingViewProtocol?
    var interactor: OnboardingInteractorIntputProtocol?
    var router: OnboardingRouterProtocol?
    
    // MARK: - Initializers
    
    init(view: OnboardingViewProtocol?, router: OnboardingRouterProtocol?) {
        self.view = view
        self.router = router
    }
}

// MARK: - OnboardingPresenterProtocol

extension OnboardingPresenter: OnboardingPresenterProtocol {
    func didTapLetsGo() {
        interactor?.saveDisplayingOnboarding()
    }
}

// MARK: - OnboardingInteractorOutputProtocol

extension OnboardingPresenter: OnboardingInteractorOutputProtocol {
    func didSaveDisplayingOnboarding() {
        router?.loadMain()
    }
}
