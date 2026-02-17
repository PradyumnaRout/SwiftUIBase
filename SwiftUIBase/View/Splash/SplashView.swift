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
        .environment(router)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                router.goToAuth()
                router.goToMainApp()
            }
        }
    }
}

struct AppRootContainerView: View {
    @EnvironmentObject var lockManager: AppLockManager
    @Environment(\.isNetworkConnectd) private var isNetworkConnected
    @Environment(AlertManager.self) private var alertManager
    
    var body: some View {
        ZStack {
            RootView()
            // Show loading or authentication UI
            if lockManager.isAuthenticating {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
            
            if let alert = alertManager.alert {
                AlertView(alert: alert, onDismiss: alertManager.dismiss)
            }
        }
        .animation(.interactiveSpring(duration: 0.5), value: alertManager.alert)
        .fullScreenCover(isPresented: .constant(!(isNetworkConnected ?? true))) {
            NoInternetView()
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
            NavigationStack(path: router.currentPath) {
                LoginView()
                    .environment(router)
                    .navigationDestination(for: AnyScreen.self) { screen in
                        screen.build()
                    }
            }
        }
    }
}


