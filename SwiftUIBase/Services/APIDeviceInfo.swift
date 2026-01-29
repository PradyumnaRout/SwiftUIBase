//
//  APIDeviceInfo.swift
//  MVVMBaseProject
//
//  Created by hb on 31/07/23.
//

import Foundation
import UIKit

class APIDeviceInfo: NSObject {
    class var deviceInfo: [String: Any] {
        var infoParams = [String: Any]()
        infoParams["device_type"] = AppConstants.platform.lowercased()
        infoParams["device_os"] = AppConstants.os_version
        infoParams["device_token"] = UserDefaultsManager.deviceToken
        infoParams["device_name"] = AppConstants.device_name
        infoParams["app_version"] = AppInfo.kAppVersion
        infoParams["device_udid"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        infoParams["access_token"] = UserDefaultsManager.webServiceToken
        infoParams["ws_token"] = UserDefaultsManager.webServiceToken
        infoParams["utc_offset"] = TimeZone.utcOffset()
        return infoParams
    }
}
