//
//  EnvironmentManager.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import Foundation

enum AppEnvironment {
    private static let baseUrlKey = "BASE_URL"
    private static let environmentKey = "ENVIRONMENT"
    
    static var baseURl: String? {
        guard let baseURl = Bundle.main.infoDictionary?[baseUrlKey] as? String else { return nil }
        return baseURl
    }
    
    static var env: String? {
        guard let envValue = Bundle.main.infoDictionary?[environmentKey] as? String else { return nil }
        return envValue
    }
}
