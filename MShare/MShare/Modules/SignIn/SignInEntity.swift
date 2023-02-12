//
//  SignInEntity.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 05.02.2023.
//

import AuthenticationServices

struct SignInUser {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
    init(credentials: ASAuthorizationAppleIDCredential) {
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
    }
}
