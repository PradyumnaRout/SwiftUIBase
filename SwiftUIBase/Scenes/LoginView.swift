//
//  LoginView.swift
//  SwiftUIBase
//
//  Created by hb on 30/01/26.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(NavRouter.self) private var router

    @State private var user: AuthUser?

    var body: some View {
        VStack(spacing: 20) {
            Button("Sign in with Apple") {
                AuthService.shared.signIn(with: .apple) { result in
                    handle(result)
                }
            }

            Button("Sign in with Google") {
                AuthService.shared.signIn(with: .google) { result in
                    handle(result)
                }
            }

            if let user = user {
                Text("Logged in as \(user.name ?? "Unknown")")
            }
        }
    }

    func handle(_ result: Result<AuthUser, Error>) {
        switch result {
        case .success(let user):
            self.user = user
            print("✅ Logged in:", user)
            router.goToMainApp()
            
        case .failure(let error):
            print("❌ Error:", error)
        }
    }
}

