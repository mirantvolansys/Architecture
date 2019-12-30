//
//  PushNotification.swift
//  CoreComponents
//
//  Created by Yogesh Makwana on 19/07/19.
//  Copyright © 2019 Volansys Technologies. All rights reserved.
//

import UserNotifications
import UserNotificationsUI
import UIKit

//MARK: Register for local/remote push notification and get device token
extension AppDelegate {
    
    static var registerHandler: ((_ deviceToken: String?, _ error: Error?) -> Void)?
    
    func pushNotificationRegister(handler:@escaping (_ deviceToken: String?, _ error: Error?) -> Void) {
        AppDelegate.registerHandler = handler
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                // 1. Attempt registration for remote notifications on the main thread
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //We can get device token by deviceTokenMain by this delegate method
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)}) // Convert token to string
        AppDelegate.registerHandler?(deviceTokenString,nil)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        AppDelegate.registerHandler?(nil,error)
    }
}

//MARK: extension of appdelegate when app is in foreground then also we can get notification pop up
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
