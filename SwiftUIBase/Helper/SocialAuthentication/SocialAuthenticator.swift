//
//  SocialAuthenticator.swift
//  SwiftUIBase
//
//  Created by hb on 30/01/26.
//

import Foundation

struct AuthUser {
    let id: String
    let email: String?
    let name: String?
    let provider: AuthProvider
}


enum AuthProvider {
    case apple
    case google
}

protocol AuthProviderProtocol {
    func signIn(completion: @escaping (Result<AuthUser, Error>) -> Void)
    func signOut()
}
