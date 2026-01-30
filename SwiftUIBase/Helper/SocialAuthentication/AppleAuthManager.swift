//
//  AppleAuthManager.swift
//  SwiftUIBase
//
//  Created by hb on 30/01/26.
//

// https://www.createwithswift.com/sign-in-with-apple-on-a-swiftui-application/

import Foundation
import AuthenticationServices

final class AppleAuthManager: NSObject, AuthProviderProtocol {
    private var completion: ((Result<AuthUser, Error>) -> Void)?
    
    func signIn(completion: @escaping (Result<AuthUser, Error>) -> Void) {
        self.completion = completion
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func signOut() {}
}

// MARK: Apple authentication delegates
extension AppleAuthManager: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        let user = AuthUser(
            id: credential.user,
            email: credential.email,
            name: credential.fullName?.givenName,
            provider: .apple
        )
        
        completion?(.success(user))
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        completion?(.failure(error))
    }
}

extension AppleAuthManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(
        for controller: ASAuthorizationController
    ) -> ASPresentationAnchor {
        UIApplication.shared.windows.first!
    }
}
