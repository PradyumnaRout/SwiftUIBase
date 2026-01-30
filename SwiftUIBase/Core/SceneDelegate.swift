//
//  SceneDelegate.swift
//  SwiftUIBase
//
//  Created by hb on 29/01/26.
//

import Foundation
import UIKit

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        print("SceneDelegate is connected!")
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("Enter Foreground")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("Enter Background")
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("App Become Active")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("App Will Resign Active")
    }
    
    class func getDelegate() -> UIWindowSceneDelegate? {
        let scene = UIApplication.shared.connectedScenes.first
        if let sd: UIWindowSceneDelegate = (scene?.delegate as? UIWindowSceneDelegate) {
            return sd
        }
        return nil
    }
}

