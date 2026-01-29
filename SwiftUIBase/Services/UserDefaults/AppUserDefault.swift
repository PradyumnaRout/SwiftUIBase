//
//  AppUserDefault.swift
//  MVVMBaseProject
//
//  Created by hb on 25/07/23.
//

import Foundation

let AppUserDefaults = UserDefaults.standard

struct UserDefaultsKey {
    static let deviceToken = "device_token"
    static let authToken = "auth_token"
    static let logedInUser = "logedInUser"
    static let deviceTokenKey = "deviceTokenKey"
    static let ws_token = "ws_token"
    static let userDetail = "user_detail"
    static let userLocationDetail = "user_Locationdetail"
    static let userID = "user_id"
    static let accessToken = "access_token"
    static let deviceTokenDataKey = "deviceTokenDataKey"
    static let LockScreen = "lock_screen"
    static var longitude = "longitude"
    static var latitude = "latitute"
}

struct UserTokenKey {
    static let deviceTokenDataKey = "deviceTokenDataKey"
}
