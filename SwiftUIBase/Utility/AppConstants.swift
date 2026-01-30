//
//  AppConstants.swift
//  MVVMBaseProject
//
//  Created by hb on 12/07/23.
//

import Foundation
import UIKit

struct AppConstants {
    
    static let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3d3dy5naXZzcGlyZS5jb20vIiwiYXVkIjoiaHR0cHM6Ly93d3cuZ2l2c3BpcmUuY29tLyIsImlhdCI6MTczNTI3NDg1Mi41NDA3ODIsImV4cCI6MTc2NjM3ODg1Mi41NDA3ODIsImp0aSI6IkNJVEBXU0BKV1QhIiwiY3VzdG9tZXJfaWQiOiIxMDUiLCJ0X25hbWUiOiJTYW1haXJhIFdvb2RzIiwidF9lbWFpbCI6InM1YzZ2Z2JnaDVAcHJpdmF0ZXJlbGF5LmFwcGxlaWQuY29tIiwidF90eXBlIjoiTlBPIiwidF9mb3JjZV9sb2dvdXQiOiIiLCJ0X3BsYXRmb3JtIjoiaU9TIiwidF9kZXZpY2Vfb3MiOiIxNy4zLjEiLCJ0X2RldmljZV9uYW1lIjoiaVBob25lIiwidF9kZXZpY2VfdG9rZW4iOiJmdGxpQXk5emkwRkxnVE9HRFJ1RVM0OkFQQTkxYkZ1RERNYm9aY3RfNERnOG56c0FYRjRRSlRkNjdiZzRlMmVvY0l0R1FWU2NXc0dUbUgwVXpyaGh1UndScnFGWlBsX1JUMENWZ3QtT0JrdWVPX24zOWQxeTJpMzh3RlRmaFFOc1A1ZGhkT2hlMS02TjhzIn0.uUjoXNs8MmzqCloOYOqElT0bbtt2IJ0ngPgXgzzNbJw"
    
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let baseUrl = AppEnvironment.baseURl
    static var enableEncryption = false
    static var enableChecksum = false
    
    //32 characters long. Each character is 1 byte (in UTF-8 encoding). So it's 32 bytes, which is: 256 bits (since 1 byte = 8 bits)
    static let aesEncryptionKey = "12345678901234567890123456789012"   //User defined.
    
    static let ws_checksum = "ws_checksum"
    static let deviceId = UIDevice.current.identifierForVendor?.uuidString
    static let device_name = UIDevice.current.name
    static let platform = "iOS"
    static let os_version = UIDevice.current.systemVersion
    static var accessToken: String?
//    static let iS_Simulator = (TARGET_IPHONE_SIMULATOR == 1)
    static let useAES256Encryption: Bool = false
}

struct AppInfo {
    static let kAppName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "App"
    static let kAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    static let kAppBuildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1.0"
    static let kBundleIdentifier = ""
    static let kAppstoreID = ""
}


// MARK: Disable print for production.

// Enable or Disable Print Log
//public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
//    if AppEnvironment.isDebug == true {
//        let output = items.map { "\($0)" }.joined(separator: separator)
//        Swift.print(output, terminator: terminator)
//    }
//}


struct AppDateFormats {
    static let kDisplay = "dd-MM-yyyy"
    static let kServerAPI = "yyyy-MM-dd"
    static let kServerFullAPI = "yyyy-MM-dd HH:mm:ss"
    static let kDsiplayDay = "EE"
    static let kDsiplayDate = "dd"
    static let kDsiplayMonth = "MMM"
    static let kServerDate = "dd/MM/yyyy"
    static let kDisplayDate = "dd MMM yyyy"
    static let kDisplay2Char = "dd-MM-yy"
    static let KShortDateMonth = "d/MM"
    static let kDisplayDayDate = "EE, dd MMM yyyy"
    static let kDisplayDayDateTime = "EE, dd MMM yyyy, hh:mm a"
}

struct AppTimeFormats {
    static let kDisplay = "HH:mm"
    static let kServerAPI = "HH:mm:ss"
    static let kDisplay12Hours = "hh:mm a"
}

struct AppColors {
    static let Red = UIColor.red
}

struct AppImages {
    static let arrow = UIImage(systemName: "arrow")
}
