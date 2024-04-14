//
//  OnboardingInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.01.2023.
//

import Foundation

protocol OnboardingInteractorIntputProtocol {
    var presenter: OnboardingInteractorOutputProtocol? { get set }
    
    func saveDisplayingOnboarding()
}

protocol OnboardingInteractorOutputProtocol: AnyObject {
    func didSaveDisplayingOnboarding()
}

final class OnboardingInteractor {
    weak var presenter: OnboardingInteractorOutputProtocol?
    
    // MARK: - Initializers
    
    init(
        presenter: OnboardingInteractorOutputProtocol?,
        userManager: UserManagerProtocol
    ) {
        self.userManager = userManager
        self.presenter = presenter
    }
    
    // MARK: - Private
    
    private var userManager: UserManagerProtocol
}

// MARK: - OnboardingInteractorInputProtocol

extension OnboardingInteractor: OnboardingInteractorIntputProtocol {
    func saveDisplayingOnboarding() {
        userManager.isDisplayOnboarding = true
        
        presenter?.didSaveDisplayingOnboarding()
    }
}
