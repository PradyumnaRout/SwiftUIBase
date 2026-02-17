//
//  CustomEnvironments.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import SwiftUI

// MARK: Router Environment key/values
struct RouterEnvKey: EnvironmentKey {
    static var defaultValue: NavRouter = NavRouter()
}

extension EnvironmentValues {
    var routerEnv: NavRouter {
        get {
            self[RouterEnvKey.self]
        } set {
            self[RouterEnvKey.self] = newValue
        }
    }
    
    @Entry var isNetworkConnectd: Bool?
}
