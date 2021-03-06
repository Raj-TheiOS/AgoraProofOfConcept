//
//  AppDelegate.swift
//  AgoraPOC
//
//  Created by Arjun  on 07/01/21.
//  Copyright © 2021 Raj. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , MessagingDelegate{



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
       if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        return true
    }
       // MARK: - MessagingDelegate

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

       func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
           print("devicetoken")
           print(token)
           Messaging.messaging().apnsToken = deviceToken
       }
       func application(
         _ application: UIApplication,
         didFailToRegisterForRemoteNotificationsWithError error: Error) {
         print("Failed to register: \(error)")
       }

       func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
         // If you are receiving a notification message while your app is in the background,
         // this callback will not be fired till the user taps on the notification launching the application.
         // TODO: Handle data of notification

         // With swizzling disabled you must let Messaging know about the message, for Analytics
         // Messaging.messaging().appDidReceiveMessage(userInfo)

         // Print message ID.
         if let messageID = userInfo["gcmMessageIDKey"] {
           print("Message ID: \(messageID)")
         }

         // Print full message.
         print(userInfo)
       }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo["gcmMessageIDKey"] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
 /*   func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
      let userInfo = response.notification.request.content.userInfo
      // Print message ID.
      if let messageID = userInfo["gcmMessageIDKey"] {
        print("Message ID: \(messageID)")
      }

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print full message.
      print(userInfo)

      completionHandler()
    }
    
          @available(iOS 10, *)
              // Receive displayed notifications for iOS 10 devices.
           func userNotificationCenter(_ center: UNUserNotificationCenter,
                                          willPresent notification: UNNotification,
                                          withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
              
                let userInfo = notification.request.content.userInfo
                print(userInfo)
    
                  completionHandler([.alert, .badge, .sound])
                  // With swizzling disabled you must let Messaging know about the message, for Analytics
                  // Messaging.messaging().appDidReceiveMessage(userInfo)
                  
                  // Print message ID.
                  if let messageID = userInfo["gcmMessageIDKey"] {
                      print("Message ID: \(messageID)")
                  }

                  
                  // Change this to your preferred presentation option
               //   completionHandler([.alert, .badge, .sound])
              } */

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo["gcmMessageIDKey"] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo["gcmMessageIDKey"] {
      print("Message ID: \(messageID)")
    }

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}
