//
//  SplashView.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import SwiftUI

struct SplashView: View {

//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 60))
            Text("My App")
                .font(.largeTitle)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                router.goToAuth()
                router.goToMainApp()
            }
        }
    }
}


// MARK: RootView will decide splash or Tabs or Authentication
struct RootView: View {

//    @EnvironmentObject var router: NavRouter
    @Environment(NavRouter.self) var router

    var body: some View {
        switch router.appFlow {
        case .splash:
            SplashView()
        case .main:
            MainTabView()
        case .auth:
            LoginView()
        }
    }
}


