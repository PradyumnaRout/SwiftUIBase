//
//  GoogleAuthManager.swift
//  SwiftUIBase
//
//  Created by hb on 30/01/26.
//
// https://paulallies.medium.com/google-sign-in-swiftui-2909e01ea4ed
//https://medium.com/@matteocuzzolin/google-sign-in-with-firebase-in-swiftui-app-c8dc7b7ed4f9

// Need reverse Client id in schema and GIDClientID in info for google signin.

import Foundation
import GoogleSignIn

final class GoogleAuthManager: AuthProviderProtocol {

    func signIn(completion: @escaping (Result<AuthUser, Error>) -> Void) {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else { return }

            let authUser = AuthUser(
                id: user.userID ?? "",
                email: user.profile?.email,
                name: user.profile?.name,
                provider: .google
            )

            completion(.success(authUser))
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
