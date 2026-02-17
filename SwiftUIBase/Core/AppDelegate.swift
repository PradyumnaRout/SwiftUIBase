//
//  AppDelegate.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//


import Foundation
import UIKit
import Network
internal import _LocationEssentials
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        print("Application launched")
        
        // For Crashlytics
//        FirebaseApp.configure()
//
//        self.registerRemoteNotification { success in
//            print("Token \(success)")
//        }
        
        // Start Updating location and after getting lat long, stopped location updation
        return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Register for remote push notification, and get device token sucess
#if canImport(HBLogger)
        HBLogger.shared.enable()    // this will enable the logs of the app
        // HBLogger.shared.disableAutoNetworkLog()    // this will disable unnecessary logs from google, facebook and firebase
#endif
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
    func applicationWillTerminate(_ application: UIApplication) {
        
        print("Application terminated")
    }
    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            return GIDSignIn.sharedInstance.handle(url)
        }
}

