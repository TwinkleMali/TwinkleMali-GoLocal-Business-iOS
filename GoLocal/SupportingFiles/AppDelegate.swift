//
//  AppDelegate.swift
//  GoLocal
//
//  Created by C100-104on 16/12/20.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseMessaging
import UserNotifications
import UserNotificationsUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK:- Window
    var window: UIWindow?
    
    //MARK:- Socket Handler Obj
    var socketIOHandler:SocketIOHandler?
    var socketHandlersAdded = false
    var arrOrderRequestMain : [OrderRequests] = []
    let notificationCenter = UNUserNotificationCenter.current()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // IQKEYBOARD
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        //LIGHT APP INTERFABE
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        //FIREBASE CONFIGURATION
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        //GOOGLE MAPS CONFIG
        GMSServices.provideAPIKey(GOOGLE_KEY)
        
        
        //CHECK USER STATUS
        checkScreenNavigation()
        
        //Register for Push Notification
        self.registerForPushNotifications()
        notificationCenter.delegate = self
                    
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
//        if socketIOHandler != nil{
//            socketIOHandler?.background()
//        }
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
//        if socketIOHandler != nil{
//           socketIOHandler?.background()
//       }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        if socketIOHandler != nil{
            socketIOHandler?.foreground()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //UPDATE TIMEZONE
        TIME_ZONE = TimeZone.current.identifier
        if socketIOHandler != nil{
           socketIOHandler?.foreground()
       }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if socketIOHandler != nil{
            socketIOHandler?.background()
        }
    }
    
    //CHECK SCREEN NAVIGATION
    func checkScreenNavigation(){
        if let _ = USER_DETAILS {
            //IsPhoneVerified = USER_DETAILS?.isPhoneVerified ?? 0
//            print("IsPhoneVerified:",IsPhoneVerified)
//            if SELECTED_COTEGORY == nil {
//                let categoryVC = CategorySelectionViewController(nibName: "CategorySelectionViewController", bundle: nil)
//                categoryVC.isFromLogin = true
//                let navVC = UINavigationController(rootViewController: categoryVC)
//                navVC.navigationBar.isHidden = true
//                APP_DELEGATE?.window?.rootViewController = navVC
//            } else {
            //INITIALIZE SOCKETIOHANDLER
                socketIOHandler = SocketIOHandler()
                setupRootTabBarViewController(tabIndex: 0)
                
//            }
        } else {
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            let navVC = UINavigationController(rootViewController: loginVC)
            navVC.navigationBar.isHidden = true
            APP_DELEGATE?.window?.rootViewController = navVC
        }
    }
    
    public func setupRootTabBarViewController(tabIndex: Int) {        
        let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
        tabBar.selectedIndex = tabIndex
        let navVC = UINavigationController(rootViewController: tabBar)
        navVC.navigationBar.isHidden = true
        APP_DELEGATE?.window?.rootViewController = navVC

    }
}

extension AppDelegate : UNUserNotificationCenterDelegate ,MessagingDelegate{
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        DEVICE_TOKEN = token
        print("Device Token: \(DEVICE_TOKEN)")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote push notification")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //print("didReceiveRemoteNotification: \(userInfo)")
        
        var isDisplayNotification = true
        
        //        if let apsObj = userInfo["aps"] as? NSDictionary,
        //            let actionId = apsObj["category"] as? String {
        
        //            if let enumNoti = Enum_NotificationType(rawValue: actionId) {
        //                isDisplayNotification = true
        //            }
        //        }
        
        if isDisplayNotification {
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
        
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        FCM_TOKEN = fcmToken ?? "1234"
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        var isDisplayNotification = true
        let userInfo = notification.request.content.userInfo
        print("willPresent: \(userInfo)")
        
        
        print("Firebase Noti \(notification)")
        let dataDict:[String: String] = ["token": FCM_TOKEN]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        let _ = notification.request.content.userInfo
        //print(userInfo)
        
        if isDisplayNotification {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Firebase Noti \(response)")
        let userInfo = response.notification.request.content.userInfo
        // let navigationController = UIApplication.shared.windows[0].rootViewController as! UINavigationController
        completionHandler()
        
    }
    
   

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                //print("Permission granted: \(granted)")
                guard granted else { return }
                
                
                self?.getNotificationSettings()
        }
    }
    

    
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            //print("Notification settings: \(settings.authorizationStatus)")
            
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
}
