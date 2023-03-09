//
//  SignInInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 05.02.2023.
//

import AuthenticationServices

protocol SignInInteractorIntputProtocol {
    var presenter: SignInInteractorOutputProtocol? { get set }
    
    func makeRequestSignInWithApple()
    func setViewedOnboarding()
}

protocol SignInInteractorOutputProtocol: AnyObject {
    func requestForSignInWithApple(_ request: ASAuthorizationAppleIDRequest, authorizationController: ((ASAuthorizationController) -> Void))
    func successedSingIn()
}

final class SignInInteractor: NSObject {
    weak var presenter: SignInInteractorOutputProtocol?
    
    private var userManager: UserManagerProtocol
    
    init(userManager: UserManagerProtocol) {
        self.userManager = userManager
    }
}

// MARK: - SignInInteractorInputProtocol

extension SignInInteractor: SignInInteractorIntputProtocol {
    
    func makeRequestSignInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        presenter?.requestForSignInWithApple(request) { [weak self] (controller) in
            controller.delegate = self
            controller.performRequests()
        }
    }
    
    func setViewedOnboarding() {
        userManager.displayOnboarding = true
    }
    
}

//MARK: - ASAuthorizationControllerDelegate

extension SignInInteractor: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
//            let user = SignInUser(credentials: credentials)
            
//            print("[dev] user id: \(user.id)")
//            print("[dev] user first name: \(user.firstName)")
//            print("[dev] user last name: \(user.lastName)")
//            print("[dev] user email: \(user.email)")
            
            guard let authorizationCodeData = credentials.authorizationCode else { return }
            
            let authorizationCode = String(data: authorizationCodeData, encoding: .utf8)
            
            print("[dev] authorizationCode: \(credentials.authorizationCode) = \(authorizationCode)")
                
            presenter?.successedSingIn()
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("[dev] error: \(error)")
    }
    
}
