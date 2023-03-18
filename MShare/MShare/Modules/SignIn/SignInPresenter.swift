//
//  SignInPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 05.02.2023.
//

import AuthenticationServices

protocol SignInPresenterProtocol: AnyObject {
    var view: SignInViewProtocol? { get set }
    var interactor: SignInInteractorIntputProtocol? { get set }
    var router: SignInRouterProtocol? { get set }
    
    func didTapPrivacyPolicy()
    func didTapSignInWithApple()
    func didTapSkip()
}

final class SignInPresenter {
    weak var view: SignInViewProtocol?
    var interactor: SignInInteractorIntputProtocol?
    var router: SignInRouterProtocol?
}

// MARK: - SignInPresenterProtocol

extension SignInPresenter: SignInPresenterProtocol {
    
    func didTapPrivacyPolicy() {
        router?.presentBrowserScreen(from: view, forUrlString: "https://www.google.com.ua")
    }
    
    func didTapSignInWithApple() {
        interactor?.makeRequestSignInWithApple()
    }
    
    func didTapSkip() {
        view?.dismissView() { [weak self] in
            self?.interactor?.setViewedOnboarding()
            self?.router?.showMain()
        }
    }
    
}

// MARK: - SignInInteractorOutputProtocol

extension SignInPresenter: SignInInteractorOutputProtocol {
    
    func requestForSignInWithApple(_ request: ASAuthorizationAppleIDRequest, authorizationController: ((ASAuthorizationController) -> Void)) {
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.presentationContextProvider = view
        
        authorizationController(controller)
    }
    
    func successedSingIn() {
        didTapSkip()
    }
      
}
