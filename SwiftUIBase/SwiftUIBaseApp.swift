//
//  SwiftUIBaseApp.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import SwiftUI

@main
struct SwiftUIBaseApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
//    @StateObject private var router = NavRouter()
    @State private var router = NavRouter()
    @StateObject private var languageManager = LanguageManager.shared
    @StateObject private var lockManager = AppLockManager()
    @StateObject private var themeManager = ThemeManager()
    @State private var networkMonitor = NetworkMonitor()
    @State private var alertManager = AlertManager()

    init() {
        let manager = LanguageManager.shared
        print("🚀 App started with language: \(manager.currentLanguage)")
        
        // Debug: Test a string
        let testString = String(localized: "Welcome Back", locale: manager.currentLocale)
        print("🧪 Test string: \(testString)")
    }
    
    var body: some Scene {
        WindowGroup {
            AppRootContainerView()
            // .environmentObject(router)
                .environment(router)
                .environmentObject(languageManager)
                .environmentObject(lockManager)
                .environmentObject(themeManager)
                .environment(\.isNetworkConnectd, networkMonitor.isConnected)
                .environment(\.locale, languageManager.currentLocale)
                .environment(alertManager)
                .id(languageManager.refreshID)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .background:
                lockManager.resetUnlockState()
                lockManager.lock()
            case .active:
                if lockManager.isLocked {
                    lockManager.unlockWithAuth()
                }
            default:
                break
            }
        }
    }
}
