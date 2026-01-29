//
//  AppDelegate+PushNotification.swift
//  MVVMBaseProject
//
//  Created by hb on 25/07/23.
//

import Foundation
import UIKit
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registerRemoteNotification(onCompletion: ((Bool) -> Void)? = nil) {
        _ = UIApplication.shared
//        application.delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
            guard error == nil else {
                // Display Error.. Handle Error.. etc..
                onCompletion?(false)
                return
            }
            
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
                onCompletion?(true)
            } else {
                // Handle user denying permissions..
                onCompletion?(false)
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaultsManager.deviceToken = deviceTokenString
        UserDefaultsManager.deviceTokenData = deviceToken
        print("Device Token ===> \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        UserDefaultsManager.deviceToken = "Error:\(AppConstants.deviceId ?? "")"
        print("i am not available in simulator \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //     self.handlePushNotification(userInfo : notification.request.content.userInfo)
        completionHandler([.banner, .list, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification
        self.handlePushNotification(userInfo: response.notification.request.content.userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        self.handlePushNotification(userInfo: userInfo)
    }
    
    func handlePushNotification(userInfo: [AnyHashable: Any]) {
        print(userInfo)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            GlobalService.shared.dictNotification = userInfo
        }
    }
    
    func hideNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
