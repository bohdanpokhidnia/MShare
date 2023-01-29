//
//  OnboardingInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.01.2023.
//

import Foundation

protocol OnboardingInteractorIntputProtocol {
    var presenter: OnboardingInteractorOutputProtocol? { get set }
    
    func showMain()
}

protocol OnboardingInteractorOutputProtocol: AnyObject {
    func displayMain()
}

final class OnboardingInteractor {
    weak var presenter: OnboardingInteractorOutputProtocol?
    
    private var userManager: UserManagerProtocol
    
    init(userManager: UserManagerProtocol) {
        self.userManager = userManager
    }
}

// MARK: - OnboardingInteractorInputProtocol

extension OnboardingInteractor: OnboardingInteractorIntputProtocol {
    
    func showMain() {
        userManager.displayOnboarding = true
        
        presenter?.displayMain()
    }
    
}
