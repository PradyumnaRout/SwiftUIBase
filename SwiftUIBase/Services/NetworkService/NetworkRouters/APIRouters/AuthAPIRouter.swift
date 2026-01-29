//
//  AuthAPIRouter.swift
//  MVVMBaseProject
//
//  Created by hb on 31/07/23.
//

import Foundation

enum AuthAPIRouter: RouterProtocol {
    
//    case login(request: Login.Request)
    case login(request: MoodLogin.Request)
    case article(request: Favorite.Request)
    
    var requestTimeOut: Float? {
        return 30
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .article:
            return .get
        }
    }
    
    var baseUrlString: String {
        switch self {
        case .login:
            return "https://www.moodfulapp.com/WS"
        default:
            return AppEnvironment.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .login:
//            return "/mob_auth/customer_login"
            return "user_login"
        case .article:
            return "https://newsapi.org/v2/everything?q=apple"
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .login(request: let request):
//            params = [
//                "email": request.email.trim(),
//                "password": request.password
//            ]
            
            params = [
                "email": request.email,
                "username": request.email,
                "password": request.password,
                "registration_type": request.registration_type,
                "registration_id": request.registration_id,
                "is_send_otp": request.is_send_otp,
                "otp_number": request.otp_number,
                "device_type": request.device_type,
                "app_version": request.app_version,
                "device_name": request.device_name,
                "device_token": request.device_token,
                "device_os": request.device_os,
                "device_id": request.device_id
            ]
            return params
        case .article(request: let request):
            params = [
                "apiKey": request.apiKey ?? "",
                "q": request.q ?? ""
            ]
        }
            
            var aParams: [String: Any]? = params
            
            if let aDeviceInfo = deviceInfo {
                if let aParameters = aParams {
                    let params = aParameters.merging(aDeviceInfo, uniquingKeysWith: { (first, _) in first })
                    aParams = params
                } else {
                    aParams = aDeviceInfo
                }
            }
            return aParams
       
    }
    
    var headers: [String: String]? {
//        let boundary = Boundary.boundary
//        return ["Content-Type": "multipart/form-data; boundary=\(boundary)", "Authorization": "Bearer " + (UserDefaultsManager.accessToken)]
        return ["Content-Type" : "application/json", "Authorization": ("Bearer " + AppConstants.token)]
    }
    
    var arrayParameters: [Any]? {
        return nil
    }
    
    var files: [MultiPartData]? {
        /*
        switch self {
        case .login(let request):
            var arr = [MultiPartData]()
            if let data = request.profilePic {
                
                arr.append(MultiPartData(fileName: request.filename, data: data, paramKey: "profile_picture", mimeType: "image/jpeg"))
            }
            return arr
        default :
            break
        }
        */
        return nil
    }
    
    var deviceInfo: [String: Any]? {
        return APIDeviceInfo.deviceInfo
    }
    
    var encryption: EncryptionConfig? {
        return nil
    }
}
