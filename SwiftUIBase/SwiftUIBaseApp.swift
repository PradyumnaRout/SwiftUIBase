//
//  SwiftUIBaseApp.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import SwiftUI

@main
struct SwiftUIBaseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
//    @StateObject private var router = NavRouter()
    @State private var router = NavRouter()
    
    var body: some Scene {
        WindowGroup {
            RootView()
//                .environmentObject(router)
                .environment(router)
        }
    }
}
