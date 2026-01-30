//
//  SessionManager.swift
//  Note
//
//  Created by HB1 on 28/09/18.
//  Copyright © 2018 HB. All rights reserved.
//

import Foundation

struct UserDefaultsManager {
    static let applicationDefaults = UserDefaults.standard
        
    static var deviceToken: String {
        get {
            return applicationDefaults.string(forKey: UserDefaultsKey.deviceTokenKey) ?? UUID().uuidString
        }
        set {
            applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.deviceTokenKey)
        }
    }
    
    static var deviceTokenData: Data {
        get {
            return (applicationDefaults.value(forKey: UserDefaultsKey.deviceTokenDataKey) as? Data) ?? Data()
        }
        set {
            applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.deviceTokenDataKey)
        }
    }
    
    static var webServiceToken: String {
        get {
            return applicationDefaults.string(forKey: UserDefaultsKey.ws_token) ?? ""
        }
        set {
            applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.ws_token)
        }
    }
    
//    static var loggedUserInfo: User.ViewModel? {
//        get {
//            guard let decoded = applicationDefaults.object(forKey: UserDefaultsKey.userDetail) as? Data else {
//                return nil
//            }
//            let decoder = JSONDecoder()
//            let decodedUser = try? decoder.decode(User.ViewModel.self, from: decoded)
//            return decodedUser
//        }
//        set {
//            if let newObject = newValue {
//                let encoder = JSONEncoder()
//                let encodedData = try? encoder.encode(newObject)
//                applicationDefaults.setValue(encodedData, forKey: UserDefaultsKey.userDetail)
//                applicationDefaults.synchronize()
//            } else {
//                applicationDefaults.removeObject(forKey: UserDefaultsKey.userDetail)
//            }
//        }
//    }
    
    static var userID: String {
        get {
            return applicationDefaults.string(forKey: UserDefaultsKey.userID) ?? ""
        }
        set {
            applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.userID)
        }
    }
    
    // User will she the same screen open by default if user can lock the screen
    // Storing selectedIndex
    static var lockScreen: Int {
        get {
            return applicationDefaults.integer(forKey: UserDefaultsKey.LockScreen)
        }
        set {
            applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.LockScreen)
        }
    }
     
    static var accessToken: String {
        get {
            return applicationDefaults.string(forKey: UserDefaultsKey.accessToken) ?? ""
        }
        set {
            applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.accessToken)
        }
    }
    
    static var longitude: Double {
        get {
            return applicationDefaults.double(forKey: UserDefaultsKey.longitude)
        }
        set {
            applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.longitude)
        }
    }
    static var latitute: Double {
        get {
            return applicationDefaults.double(forKey: UserDefaultsKey.latitude)
        }
        set {
            applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.latitude)
        }
    }
    
    static func logoutUser() {
        applicationDefaults.removeObject(forKey: UserDefaultsKey.userDetail)
        applicationDefaults.removeObject(forKey: UserDefaultsKey.accessToken)
        applicationDefaults.synchronize()
    }
}
