//
//  AppDelegate + PushNotification.swift
//  SwiftUIBase
//
//  Created by hb on 02/03/26.
//

import Foundation
import UIKit
import UserNotifications
import FirebaseMessaging
import FirebaseCore

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
        // Hands APNS token to firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaultsManager.deviceToken = deviceTokenString
        UserDefaultsManager.deviceTokenData = deviceToken
        print("Device Token ===> \(deviceTokenString)")
        
        
        // Fetch FCM Token after APNS token is set
        Messaging.messaging().token { token, error in
            if let error {
                print("FCM Token Error: \(error.localizedDescription)")
            } else if let token {
                print("FCM Token:: \(token)")
                UserDefaultsManager.fcmToken = token
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        UserDefaultsManager.deviceToken = "Error:\(AppConstants.deviceId ?? "")"
        print("i am not available in simulator \(error)")
    }
    
    // Show notification while app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        print("Foreground notification received: \(userInfo)")
        completionHandler([.banner, .list, .badge, .sound])
    }
    
    // Handle notification tap
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        self.handlePushNotification(userInfo: userInfo)
        completionHandler()
    }
    
    // Handle Background Silent Notification
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) {
        self.handlePushNotification(userInfo: userInfo)
    }
    
    func handlePushNotification(userInfo: [AnyHashable: Any]) {
        print("Push Notification Payload: \(userInfo)")
        
        do {
            // Convert [AnyHashable: Any] -> Data
            let data = try JSONSerialization.data(withJSONObject: userInfo)
            let payload = try JSONDecoder().decode(PushNotificationPayload.self, from: data)
            
            let title = payload.aps?.alert?.title ?? ""
            let body = payload.aps?.alert?.body ?? ""
            let type = NotificationType(rawValue: payload.type ?? "") ?? .unknown
            let targetID = payload.targetID ?? ""
            
            print("Title: \(title)")
            print("Body: \(body)")
            print("Type: \(type.rawValue)")
            print("Target ID: \(targetID)")
            
            routeNotification(type: type, targetID: targetID)
        } catch {
            print("Failed to decode push notification payload: \(error.localizedDescription)")
        }
    }
    
    private func routeNotification(type: NotificationType, targetID: String) {
        DispatchQueue.main.async {
            switch type {
            case .home:
                print("Navigate to home: \(targetID)")
                self.pushIntent?.notiType = .home(id: targetID)
            case .redeem:
                print("Navigate to redeem: \(targetID)")
                self.pushIntent?.notiType = .redeem(id: targetID)
            case .wallet:
                print("Navigate to wallet: \(targetID)")
                self.pushIntent?.notiType = .wallet(id: targetID)
            case .profile:
                print("Navigate to profile: \(targetID)")
                self.pushIntent?.notiType = .profile(id: targetID)
            case .unknown:
                print("Unknown notification type")
            }
        }
    }
    
    func hideNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        if #available(iOS 17.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(0) { error in
                if let error {
                    print("Failed to clear badge: \(error.localizedDescription)")
                }
            }
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}


// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Registration Token: \(String(describing: fcmToken))")
        
        guard let fcmToken else { return }
        
        // Save and send FCM token to your backend
        UserDefaultsManager.fcmToken = fcmToken
        sendFCMTokenToServer(fcmToken)
    }
    
    private func sendFCMTokenToServer(_ token: String) {
        // Send to your backend API
        print("Sending FCM token to server: \(token)")
        // APIManager.shared.updateFCMToken(token) { result in ... }
    }
}

