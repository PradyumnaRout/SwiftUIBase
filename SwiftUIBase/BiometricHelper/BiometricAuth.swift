//
//  BiometricAuth.swift
//  DropShop
//
//  Created by hb on 05/02/26.
//

import LocalAuthentication

final class BiometricAuth {
    
    static func biometricAvailability() -> Bool {

        let context = LAContext()
        var error: NSError?

        let available = context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        )

        return available
    }
    
    //.deviceOwnerAuthentication,   // By Biometric and Pin
    //.deviceOwnerAuthenticationWithBiometrics,   // Only on Biometric.
    
    // MARK:  Enable only biometric
    static func enableBiometric(completion: @escaping (Bool) -> Void) {

        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {

            context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: "Enable biometric login"
            ) { success, _ in
                DispatchQueue.main.async {
                    completion(success)
                }
            }

        } else {
            completion(false)
        }
    }
    
    // MARK: Authenticate with biometric or PIN fallback
    static func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // This policy allows both biometric and PIN
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: "Unlock to continue"
            ) { success, authError in
                DispatchQueue.main.async {
                    completion(success, authError)
                }
            }
        } else {
            completion(false, error)
        }
    }

}

