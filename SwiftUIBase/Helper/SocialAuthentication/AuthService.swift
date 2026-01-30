//
//  AuthService.swift
//  SwiftUIBase
//
//  Created by hb on 30/01/26.
//

import Foundation

final class AuthService {
    
    static let shared = AuthService()

    private let apple = AppleAuthManager()
    private let google = GoogleAuthManager()
    
    private init() {}
    
    func signIn(with provider: AuthProvider, completion: @escaping (Result<AuthUser, Error>) -> Void) {
        switch provider {
        case .apple:
            apple.signIn(completion: completion)
        case .google:
            google.signIn(completion: completion)
        }
    }
    
    func signOut(provider: AuthProvider) {
        switch provider {
        case .apple:
            apple.signOut()
        case .google:
            google.signOut()
        }
    }
}
