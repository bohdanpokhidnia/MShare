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
}

// MARK: - OnboardingInteractorInputProtocol

extension OnboardingInteractor: OnboardingInteractorIntputProtocol {
    
}
