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
    
    func didTapStartUse()
}

final class OnboardingPresenter {
    var view: OnboardingViewProtocol?
    var interactor: OnboardingInteractorIntputProtocol?
    var router: OnboardingRouterProtocol?
}

// MARK: - OnboardingPresenterProtocol

extension OnboardingPresenter: OnboardingPresenterProtocol {
    
    func didTapStartUse() {
        interactor?.showMain()
    }
    
}

// MARK: - OnboardingInteractorOutputProtocol

extension OnboardingPresenter: OnboardingInteractorOutputProtocol {
    
    func displayMain() {
        router?.showMain()
    }
    
}
