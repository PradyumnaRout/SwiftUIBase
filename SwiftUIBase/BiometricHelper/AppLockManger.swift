//
//  AppLockManger.swift
//  DropShop
//
//  Created by hb on 06/02/26.
//

import SwiftUI
import Combine

@MainActor
final class AppLockManager: ObservableObject {
    @Published var isLocked: Bool = true
        
    // Add this to track if we should enforce locking
    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false
    
    @AppStorage("unlockedByBiometric")
    private var appUnlocked = false
    
    private(set) var isAuthenticating = false
    
    var biometricEnabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: "biometricEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "biometricEnabled")
        }
    }
    
    init() {
        // Only start locked if biometric is enabled AND onboarding is complete
        self.isLocked = biometricEnabled && hasCompletedOnboarding && !appUnlocked
    }
    
    // MARK: Lock
    func lock() {
        print("======= Locked ==========")
        guard biometricEnabled && hasCompletedOnboarding else { return }
        
        if isAuthenticating { return }
        
        isLocked = true
        appUnlocked = false
        print("Locked: \(isLocked) === appUnlocked:: \(appUnlocked)")
    }
    
    
    // MARK: Unlock with authentication
    func unlockWithAuth() {
        print("======= Attempting unlock ==========")
        print("Biometric Enable: \(biometricEnabled), Has completed onboarding: \(hasCompletedOnboarding), App Unlocked: \(appUnlocked)")
        
        // If security is not enabled or already unlocked, just unlock
        guard biometricEnabled && hasCompletedOnboarding && !appUnlocked else {
            isLocked = false
            return
        }
        
        guard !isAuthenticating else { return }
        
        isAuthenticating = true
        
        BiometricAuth.authenticate { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isAuthenticating = false
                
                if success {
                    self?.isLocked = false
                    self?.appUnlocked = true
                } else {
                    print("Authentication failed: \(error?.localizedDescription ?? "Unknown error")")
                    // Keep locked if authentication fails
                }
            }
        }
    }
    
    // MARK: Complete onboarding and activate biometric protection
    func completeOnboarding() {
        hasCompletedOnboarding = true
        if biometricEnabled {
            isLocked = false // Start unlocked after onboarding
            appUnlocked = true
        }
    }
    
    // MARK: Reset unlock state (call when app enters background)
    func resetUnlockState() {
        guard biometricEnabled && hasCompletedOnboarding else { return }
        appUnlocked = false
    }
}
