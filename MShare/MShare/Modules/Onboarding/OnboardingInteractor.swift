//
//  OnboardingInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.01.2023.
//

import Foundation

protocol OnboardingInteractorIntputProtocol {
    var presenter: OnboardingInteractorOutputProtocol? { get set }
}

protocol OnboardingInteractorOutputProtocol: AnyObject {
    
}

final class OnboardingInteractor {
    weak var presenter: OnboardingInteractorOutputProtocol?
    
    // MARK: - Initializers
    
    init(presenter: OnboardingInteractorOutputProtocol?) {
        self.presenter = presenter
    }
}

// MARK: - OnboardingInteractorInputProtocol

extension OnboardingInteractor: OnboardingInteractorIntputProtocol {
    
}
