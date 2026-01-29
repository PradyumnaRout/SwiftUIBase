//
//  APIDataConverter.swift
//  CombineMVVM
//
//  Created by hb on 7/21/22.
//

import Foundation

open class WSResponseSetting: Codable {
    
    public var success: String?
    public var message: String?
    public var count: String?
    public var nextPage: String?
    public var accessToken: String?
    public var fields: [String]?
    public let currPage: String?
    public let perPage: String?
    public let prevPage: String?
   
    var isNextPage: Bool {
        return (nextPage != nil && nextPage! == "1")
    }
    
    var isSuccess: Bool {
        return (success != nil && success! != "0")
    }
    
    var isValidToken: Bool {
        guard let success = success else { return false }
        let tokenFailArray = ["-200", "-300", "-500", "-2", "-3", "-5"]
        return !tokenFailArray.contains(success)
    }
    
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case count = "count"
        case nextPage = "next_page"
        case accessToken = "access_token"
        case fields = "fields"
        case currPage = "curr_page"
        case perPage = "per_page"
        case prevPage = "prev_page"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(success, forKey: .success)
        try container.encode(message, forKey: .message)
        try container.encode(count, forKey: .count)
        try container.encode(nextPage, forKey: .nextPage)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(fields, forKey: .fields)
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try? values.decode(String.self, forKey: .success)
        message = try? values.decode(String.self, forKey: .message)
        count = try? values.decode(String.self, forKey: .count)
        nextPage = try? values.decode(String.self, forKey: .nextPage)
        accessToken = try? values.decode(String.self, forKey: .accessToken)
        fields = try values.decodeIfPresent([String].self, forKey: .fields)
        currPage = try values.decodeIfPresent(String.self, forKey: .currPage)
        perPage = try values.decodeIfPresent(String.self, forKey: .perPage)
        prevPage = try values.decodeIfPresent(String.self, forKey: .prevPage)
    }
}

open class WSResponse<T: WSResponseData>: Codable {
    
    public var setting: WSResponseSetting?
    public var arrayData: [T]?
    public var dictData: T?

    private enum CodingKeys: String, CodingKey {
        case setting = "settings"
        case data = "data"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(setting, forKey: .setting)
        try container.encode(arrayData, forKey: .data)
        try container.encode(dictData, forKey: .data)
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        setting = try? values.decode(WSResponseSetting.self, forKey: .setting)
        arrayData = try? values.decode([T].self, forKey: .data)
        dictData = try? values.decode(T.self, forKey: .data)
    }
}

open class WSResponseData: Codable {
    
    init() {
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
    
    required public init(from decoder: Decoder) throws {
        
    }
}
