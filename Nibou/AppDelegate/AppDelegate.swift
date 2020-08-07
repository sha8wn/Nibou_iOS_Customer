//
//  AppDelegate.swift
//  Nibou
//
//  Created by Ongraph on 5/8/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseMessaging
import Stripe
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window              : UIWindow?
    var isOpenHome          : Bool                   = false
    var webClient           : ActionCableClient!     = nil
    var notficationChannel  : Channel!               = nil
    var kdeviceIdValueKey   : String! = "123"
    var kdeviceFCMToken     : String! = "123"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let model: LoginModel = getAccessTokenModel()
        if model.accessToken != ""{
            self.setUpWebSocket()
        }else{
        }
        
        IQKeyboardManager.shared.enable = true

        if getLanguage() == "ar"{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        UNUserNotificationCenter.current().delegate = self
        self.setupPushNotfication(application: application)
        
        STPPaymentConfiguration.shared().publishableKey = kStripePublishableKey
        STPPaymentConfiguration.shared().appleMerchantIdentifier = kStripeMerchantIdentifier

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if self.webClient != nil{
            self.webClient.disconnect()
            self.notficationChannel.unsubscribe()
        }
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        let model: LoginModel = getAccessTokenModel()
        if model.accessToken != ""{
            self.setUpWebSocket()
        }else{
            
        }
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DEVICE_FOREGROUND"), object: nil)
        let model: LoginModel = getAccessTokenModel()
        if model.accessToken != ""{
            self.setUpWebSocket()
        }else{
            
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        self.webClient.disconnect()
        self.notficationChannel.unsubscribe()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Nibou")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


extension AppDelegate{
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        kdeviceIdValueKey = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("---------------------------------------")
        print("APNs device token: \(kdeviceIdValueKey!)")
        print("---------------------------------------")
    }
}


extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        kdeviceFCMToken = fcmToken
        print("---------------------------------------")
        print("fcmToken===\(fcmToken)")
        print("---------------------------------------")
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        var responseDict = NSMutableDictionary(dictionary: userInfo)
        if responseDict["localNotification"] as? Bool != nil{
//            responseDict["localNotification"] = false
        }else{
            responseDict["localNotification"] = false
        }
        self.handlePushNotification(data: responseDict as! [AnyHashable : Any])
        completionHandler()
    }
    
    //MARK: - PushNotfication
    /**
     This function is used to receieve PushNotfication
     */
    func setupPushNotfication(application : UIApplication){
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
    }
}
