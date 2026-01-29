//
//  RouterProtocol.swift
//  CombineMVVM
//
//  Created by hb on 7/14/22.
//

import Foundation

public protocol RouterProtocol: RequestConvertible {
    var requestTimeOut: Float? { get }
    var method: HTTPMethod { get }
    var baseUrlString: String { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var arrayParameters: [Any]? { get }
    var files: [MultiPartData]? { get }
    var deviceInfo: [String: Any]? { get }
    var encryption: EncryptionConfig? { get }
}

public extension RouterProtocol {
    
    func buildURLRequest() throws -> URLRequest {
        let aParams: [String: Any]? = parameters
        let boundary = Boundary.boundary
        
        // Validate base URL
        guard let baseURL = URL(string: self.baseUrlString) else {
            throw NetworkError.requestError(errorMessage: "Unable to create base URL")
        }
        
        // Construct final URL with path
        let url: URL
        if path.hasPrefix("http://") || path.hasPrefix("https://") {
            guard let pathURL = URL(string: path) else {
                throw NetworkError.requestError(errorMessage: "Invalid path URL")
            }
            url = pathURL
        } else {
            url = baseURL.appendingPathComponent(path)
        }

        if(method == .get) {
            var getUrl = URLComponents(string: url.absoluteString)
            if let params = aParams {
                var queryItem: [URLQueryItem]?
                for (key, value) in params {
                    if(queryItem != nil) {
                        
                        queryItem?.append(URLQueryItem(name: key, value: value as? String))
                    } else {
                        queryItem = [URLQueryItem(name: key, value: value as? String)]
                    }
                }
                getUrl?.queryItems = queryItem
            }
            var urlRequest = URLRequest(url: getUrl?.url ?? url)
            urlRequest.httpMethod = method.rawValue
            return urlRequest
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        if let headers = headers {
            for (key, value) in headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        urlRequest.timeoutInterval = 300 // 5 minutes
        let contentType = urlRequest.value(forHTTPHeaderField: "Content-Type")
        if(contentType?.contains("multipart/form-data") == true) {
            let dataBody = createDataBody(withParameters: aParams, media: files, boundary: boundary)
            
            if AppConstants.useAES256Encryption {
                if let jsonString = String(data: dataBody, encoding: .utf8) {
                    let encryptedBody = try AES256.shared.encrypt(string: jsonString)
                    urlRequest.httpBody = encryptedBody
                } else {
                    throw NetworkError.requestError(errorMessage: "Json String conversion failed")
                }
            } else {
                urlRequest.httpBody = dataBody
            }
        } else {
           /**
            var postString: String?
            if encryption != nil {
                postString = NetworkEncryption.json(from: NetworkEncryption.applyEncryptionIfRequired(request: self))
            } else {
                postString = getPostString(params: aParams)
            }
            let aData = postString?.data(using: .utf8)
            urlRequest.httpBody = aData
            */
            
            if let parameters = self.parameters {
                // Serialize parameters as JSON for non-multipart requests
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                do {
                    
                    let jsonSerializationData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    
                    if AppConstants.useAES256Encryption {
                        if let jsonString = String(data: jsonSerializationData, encoding: .utf8) {
                            let encryptedBody = try AES256.shared.encrypt(string: jsonString)
                            urlRequest.httpBody = encryptedBody
                        } else {
                            throw NetworkError.requestError(errorMessage: "Json String conversion failed")
                        }
                    } else {
                        urlRequest.httpBody = jsonSerializationData
                    }
                    
                } catch {
                    throw NetworkError.requestError(errorMessage: "Failed to serialize parameters: \(error.localizedDescription)")
                }
            }
        }
        return urlRequest
    }
    
    func buildURLRequest(with url: URL) -> URLRequest {
        let aParams: [String: Any]? = parameters
        let boundary = Boundary.boundary
        
        if(method == .get) {
            var getUrl = URLComponents(string: url.absoluteString)
            if let params = aParams {
                var queryItem: [URLQueryItem]?
                for (key, value) in params {
                    if(queryItem != nil) {
                        
                        queryItem?.append(URLQueryItem(name: key, value: value as? String))
                    } else {
                        queryItem = [URLQueryItem(name: key, value: value as? String)]
                    }
                }
                getUrl?.queryItems = queryItem
            }
            var urlRequest = URLRequest(url: getUrl?.url ?? url)
            urlRequest.httpMethod = method.rawValue
            return urlRequest
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        if let headers = headers {
            for (key, value) in headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        let contentType = urlRequest.value(forHTTPHeaderField: "Content-Type")
        if(contentType?.contains("multipart/form-data") == true) {
            let dataBody = createDataBody(withParameters: aParams, media: files, boundary: boundary)
            urlRequest.httpBody = dataBody
        } else {
            var postString: String?
            if encryption != nil {
                postString = NetworkEncryption.json(from: NetworkEncryption.applyEncryptionIfRequired(request: self))
            } else {
                postString = getPostString(params: aParams)
            }
            let aData = postString?.data(using: .utf8)
            urlRequest.httpBody = aData
        }
        return urlRequest
    }
    
    func getPostString(params: [String: Any]?) -> String {
        var data = [String]()
        if let parameters = params {
            for(key, value) in parameters {
                data.append(key + "=\(value)")
            }
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    func createDataBody(withParameters parameters: [String: Any]?, media: [MultiPartData]?, boundary: String) -> Data {
        var body = Data()
        if parameters != nil {
            let finalParma = NetworkEncryption.applyEncryptionIfRequired(request: self)
            for (key, value) in finalParma {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        if let media = media {
            for file in media {
                body.append("--\(boundary)\r\n".data(using: .utf8) ?? Data())
                body.append("Content-Disposition: form-data; name=\"\(file.paramKey ?? "")\"; filename=\"\(file.fileName ?? "")\"\r\n".data(using: String.Encoding.utf8) ?? Data())
                body.append("Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8) ?? Data())
                body.append(file.data ?? Data())
                body.append("\r\n".data(using: .utf8) ?? Data())
            }
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8) ?? Data())
        return body
    }
    
    func buildGraphQLRequest(with url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        if let headers = headers {
            for (key, value) in headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
//        urlRequest.addValue("MEETUP_AFFIL=affil=meetup; MEETUP_BROWSER_ID=id=605caf27-99c3-481b-8edb-b7e3d4f21390; MEETUP_CSRF=63b306f7-87f6-46af-9b78-d95acd569c18; MEETUP_MEMBER=id=0&status=1&timestamp=1673953470&bs=0&tz=US%2FEastern&zip=&country=us&city=&state=&lat=0.0&lon=0.0&ql=false&s=2ff37925ba1b7d3a849b38f08794d98355fb4b43&scope=ALL; MEETUP_TRACK=id=dc59c20f-88c6-4132-935b-a2886c93aa93&l=0&s=e75115d0de9fe925974b9d75a73237c7d8570882; SIFT_SESSION_ID=3c4fb27f-dac6-4400-9279-9b70a2c9e51c", forHTTPHeaderField: "Cookie")
        var graphQLParmas = ""
        if let parmas = parameters {
            for (_, value) in parmas {
                if let paramsValue = value as? String {
                    graphQLParmas = paramsValue
                }
            }
        }
        let postData = graphQLParmas.data(using: .utf8)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = postData
        return urlRequest
    }
}

public protocol RequestConvertible {
    func buildGraphQLRequest(with url: URL) -> URLRequest
    func buildURLRequest(with url: URL) -> URLRequest
}

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    public static let delete = HTTPMethod(rawValue: "DELETE")
    public static let get = HTTPMethod(rawValue: "GET")
    public static let head = HTTPMethod(rawValue: "HEAD")
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    public static let patch = HTTPMethod(rawValue: "PATCH")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")
    public static let query = HTTPMethod(rawValue: "QUERY")
    public static let trace = HTTPMethod(rawValue: "TRACE")
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

fileprivate struct EncryptionKeys {
    var checksumKey: String = ""
    var passwordKey: String = ""
}

class NetworkEncryption: NSObject {
    static let shared = NetworkEncryption()
    fileprivate var encryptionKeys: EncryptionKeys?
    
    func setupEncryption(checksum: String?, password: String?) {
        NetworkEncryption.shared.encryptionKeys = EncryptionKeys(checksumKey: checksum ?? "", passwordKey: password ?? "")
    }
}

extension NetworkEncryption {
    enum EncryptionType {
        case kWithChecksumSHA
        case kWithAES
        case kWithChecksumOnly
        case kNone
    }
   
    
    static func applyEncryptionIfRequired(request: RouterProtocol) -> [String: Any] {
        
        guard let parameters = request.parameters, let encryptionConfig = request.encryption else {
            return request.parameters ?? [:]
        }
        
        switch encryptionConfig.type {
        case .kNone:
            return parameters
     
        /*case .kWithAES:
            let encParam = NetworkEncryption.encryptParamsWithAES(config: encryptionConfig, params: parameters)
            return encParam
        case .kWithChecksumSHA:
            let encParam = NetworkEncryption.encryptParamsWithChecksumSHA(config: encryptionConfig, params: parameters)
            return encParam
        case .kWithChecksumOnly:
            let encParam = NetworkEncryption.encryptParamsWithChecksumOnly(config: encryptionConfig, params: parameters)
            return encParam
         */
            
        default:
            return [:]
        }
    }
    
    /*
     static private func encryptParamsWithChecksumSHA(config: EncryptionConfig, params: [String: Any]) -> [String: Any] {
        guard let password = NetworkEncryption.shared.encryptionKeys?.passwordKey, password.isEmpty == false else {
            fatalError("Encryption Setup is remain, try HBWSNetworkService.shared.setupEncryption(checksum: CHECKSUM, password: PWD)")
        }
        
        guard let checksum = NetworkEncryption.shared.encryptionKeys?.checksumKey, checksum.isEmpty == false else {
            fatalError("Encryption Setup is remain, try HBWSNetworkService.shared.setupEncryption(checksum: CHECKSUM, password: PWD)")
        }
        
        let sortedKeys = params.keys.sorted(by: {$0 < $1})
        var input_sha = ""
        var outputParams = [String: Any]()
        for key in sortedKeys {
            if let strVal = params[key] as? String {
                if (config.ignorableKeys ?? []).contains(key) == true {
                    input_sha = "\(input_sha)\(key)=\(strVal)"
                    outputParams[key] = strVal
                } else if strVal == "FILE" {
                    input_sha = "\(input_sha)\(key)="
                } else {
                    let encryptedVal = AESCrypt.encrypt(strVal, password: password, isPreviewApp: false)
                    input_sha = "\(input_sha)\(key)=\(encryptedVal!)"
                    outputParams[key] = encryptedVal
                }
            } else {
                input_sha = "\(input_sha)\(key)="
                outputParams[key] = params[key]
            }
        }
        if let sha1_val = AESCrypt.getSHA1(input_sha) {
            outputParams[checksum] = sha1_val
        }
        
        return outputParams
    }
    
    static private func encryptParamsWithAES(config: EncryptionConfig, params: [String: Any]) -> [String: Any] {
        guard let password = NetworkEncryption.shared.encryptionKeys?.passwordKey, password.isEmpty == false else {
            fatalError("Encryption Setup is remain, try HBWSNetworkService.shared.setupEncryption(checksum: CHECKSUM, password: PWD)")
        }
        
        let sortedKeys = params.keys.sorted(by: {$0 < $1})
        var outputParams = [String: Any]()
        for key in sortedKeys {
            if let strVal = params[key] as? String {
                if (config.ignorableKeys ?? []).contains(key) == true {
                    outputParams[key] = strVal
                } else if strVal == "FILE" {
                } else {
                    let encryptedVal = AESCrypt.encrypt(strVal, password: password, isPreviewApp: false)
                    outputParams[key] = encryptedVal
                }
            } else {
                outputParams[key] = params[key]
            }
        }
        return outputParams
    }
    
    static private func encryptParamsWithChecksumOnly(config: EncryptionConfig, params: [String: Any]) -> [String: Any] {
        guard let checksum = NetworkEncryption.shared.encryptionKeys?.checksumKey, checksum.isEmpty == false else {
            fatalError("Encryption Setup is remain, try HBWSNetworkService.shared.setupEncryption(checksum: CHECKSUM, password: PWD)")
        }
        
        let sortedKeys = params.keys.sorted(by: {$0 < $1})
        var input_sha = ""
        var outputParams = params
        for key in sortedKeys {
            if let strVal = params[key] as? String {
                if (config.ignorableKeys ?? []).contains(key) == true {
                    input_sha = "\(input_sha)\(key)=\(strVal)"
                } else if strVal == "FILE" {
                    input_sha = "\(input_sha)\(key)="
                } else {
                    input_sha = "\(input_sha)\(key)=\(strVal)"
                }
            } else {
                input_sha = "\(input_sha)\(key)="
            }
        }
        if let sha1_val = AESCrypt.getSHA1(input_sha) {
            outputParams[checksum] = sha1_val
        }
        
        return outputParams
    }
    */
    
    static func json(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}

public struct EncryptionConfig {
    var type: NetworkEncryption.EncryptionType
    var ignorableKeys: [String]?
}
