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
import SwiftyJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK:- Window
    var window: UIWindow?
    
    //MARK:- Socket Handler Obj
    var socketIOHandler:SocketIOHandler?
    var socketHandlersAdded = false
    
    //MARK:- Comman Obj
    var arrOrderRequestMain : [OrderRequests] = []
    
    //MARK:- Notification Obj
    let notificationCenter = UNUserNotificationCenter.current()
    
    fileprivate var application : UIApplication?
    
    lazy var passcodeLockPresenter: PasscodeLockPresenter = {
        
        let configuration = PasscodeLockConfiguration()
        let presenter = PasscodeLockPresenter(mainWindow: self.window, configuration: configuration)
        
        return presenter
    }()
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let repository = UserDefaultsPasscodeRepository()
        let configuration = PasscodeLockConfiguration(repository: repository)
        let hasPasscode = configuration.repository.hasPasscode
        if hasPasscode {
            self.passcodeLockPresenter.present()
        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //CHECK USER STATUS
        checkScreenNavigation()
        self.application = application
        // IQKEYBOARD
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        //LIGHT APP INTERFABE
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        //FIREBASE CONFIGURATION
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        Messaging.messaging().delegate = self
        
        //GOOGLE MAPS CONFIG
        GMSPlacesClient.provideAPIKey(GOOGLE_KEY)
        GMSServices.provideAPIKey(GOOGLE_KEY)
        
        //NOTIFICATION MANAGE
        let remoteNotif = launchOptions?[.remoteNotification] as? NSDictionary
        let keyExists = remoteNotif?["aps"] != nil
        if /*remoteNotif != nil*/keyExists {
            IS_APP_OPEN_FROM_NOTIFICATION_LAUNCH = true
        }
        else {
            IS_APP_OPEN_FROM_NOTIFICATION_LAUNCH = false
        }

        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        //Register for Push Notification
        
        notificationCenter.delegate = self
        self.registerForPushNotifications()
        //self.getNotificationSettings()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if socketIOHandler != nil{
            socketIOHandler?.background()
        }
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        IS_APP_OPEN_FROM_NOTIFICATION_LAUNCH = false
        if socketIOHandler != nil{
           socketIOHandler?.background()
       }
        let repository = UserDefaultsPasscodeRepository()
        let configuration = PasscodeLockConfiguration(repository: repository)
        let hasPasscode = configuration.repository.hasPasscode
        if hasPasscode {
            self.passcodeLockPresenter.present()
        }
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
        print("Firebase registration token: \(fcmToken ?? "")")
        FCM_TOKEN = fcmToken ?? "1234"
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let isDisplayNotification = true
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
        print("didReceive: \(userInfo)")
        if ( self.application?.applicationState == UIApplication.State.inactive || self.application?.applicationState == UIApplication.State.background  )
           {
                //opened from a push notification when the app was on background
                IS_APP_OPEN_FROM_NOTIFICATION_LAUNCH = true
           }
        if IS_APP_OPEN_FROM_NOTIFICATION_LAUNCH {
            if let notificationType = userInfo[AnyHashable("notification_type")] as? String ,let notificationId = Int(notificationType) {
                switch NOTIFICATION_TYPE(rawValue: notificationId)! {
                case .NOTIFICATION_SHOP_ORDER_REQUEST:
                    if let order_id = Int(userInfo[AnyHashable("order_id")] as? String ?? "") ,order_id != 0{
                        
                        let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
                        let navVC = UINavigationController(rootViewController: tabBar)
                        navVC.navigationBar.isHidden = true
                        APP_DELEGATE?.window?.rootViewController = navVC
                    }
                break
                case .NOTIFICATION_RATING:
                    let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
                    let navVC = UINavigationController(rootViewController: tabBar)
                    navVC.navigationBar.isHidden = true
                    APP_DELEGATE?.window?.rootViewController = navVC
                    let vc = RatingViewController(nibName: "RatingViewController", bundle: .main)
                    navVC.pushViewController(vc, animated: true)
                    break
                case .NOTIFICATION_TRADE_REQUEST:
                    let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
                    tabBar.selectedIndex = 0
                    let navVC = UINavigationController(rootViewController: tabBar)
                    navVC.navigationBar.isHidden = true
                    APP_DELEGATE?.window?.rootViewController = navVC
                    break
                case .NOTIFICATION_EXTRA_CHARGE_STATUS_UPDATE:
                    if let request_id = Int(userInfo[AnyHashable("request_id")] as? String ?? "") ,
                       let response_id = Int(userInfo[AnyHashable("response_id")] as? String ?? "") {
                        let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
                        tabBar.selectedIndex = 1
                        let navVC = UINavigationController(rootViewController: tabBar)
                        navVC.navigationBar.isHidden = true
                        APP_DELEGATE?.window?.rootViewController = navVC
                        let vc = TradeOrderDetailsViewController.loadFromNib()
                        vc.viewModel.setResponseId(value: response_id)
                        navVC.pushViewController(vc, animated: true)
                    }
                    break
                case .NOTIFICATION_TRADE_PAYMENT_RECEIVED:
                    if let request_id = Int(userInfo[AnyHashable("request_id")] as? String ?? "") ,
                       let response_id = Int(userInfo[AnyHashable("response_id")] as? String ?? "") {
                        let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
                        tabBar.selectedIndex = 1
                        let navVC = UINavigationController(rootViewController: tabBar)
                        navVC.navigationBar.isHidden = true
                        APP_DELEGATE?.window?.rootViewController = navVC
                        let vc = TradeOrderDetailsViewController.loadFromNib()
                        vc.viewModel.setResponseId(value: response_id)
                        navVC.pushViewController(vc, animated: true)
                    }
                    break
                case .NOTIFICATION_CONFIRM_CASH_PAYMENT:
                    if let request_id = Int(userInfo[AnyHashable("request_id")] as? String ?? "") ,
                       let response_id = Int(userInfo[AnyHashable("response_id")] as? String ?? "") {
                        let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
                        tabBar.selectedIndex = 1
                        let navVC = UINavigationController(rootViewController: tabBar)
                        navVC.navigationBar.isHidden = true
                        APP_DELEGATE?.window?.rootViewController = navVC
                        let vc = TradeOrderDetailsViewController.loadFromNib()
                        vc.viewModel.setResponseId(value: response_id)
                        vc.showCashConfirmation = true
                        navVC.pushViewController(vc, animated: true)
                    }
                    break
                case .NOTIFICATION_TRADE_SERVICE_PAYMENT_STATUS_CHANGE,.NOTIFICATION_TRADE_PAYMENT_REQUEST:
                    if let request_id = Int(userInfo[AnyHashable("request_id")] as? String ?? "") ,
                       let response_id = Int(userInfo[AnyHashable("response_id")] as? String ?? "") {
                        let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
                        tabBar.selectedIndex = 1
                        let navVC = UINavigationController(rootViewController: tabBar)
                        navVC.navigationBar.isHidden = true
                        APP_DELEGATE?.window?.rootViewController = navVC
                        let vc = TradeOrderDetailsViewController.loadFromNib()
                        vc.viewModel.setResponseId(value: response_id)
                        navVC.pushViewController(vc, animated: true)
                    }
                    break
                case .NOTIFICATION_TRADE_QUOTE_STATUS_CHANGE:
                    if let request_id = Int(userInfo[AnyHashable("request_id")] as? String ?? "")
                        {
                        //Confirmed
                        var quotationId = 0
                        var customerId = 0
                        var businessId = 0
                        if let quotation_id = Int(userInfo[AnyHashable("quotation_id")] as? String ?? "") {
                            quotationId = quotation_id
                        }
                        if let customer_id = Int(userInfo[AnyHashable("customer_id")] as? String ?? "") {
                            customerId = customer_id
                        }
                        //reject
                        if let business_id = Int(userInfo[AnyHashable("business_id")] as? String ?? "") {
                            businessId = business_id
                        }
                        let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
                        tabBar.selectedIndex = 1
                        let navVC = UINavigationController(rootViewController: tabBar)
                        navVC.navigationBar.isHidden = true
                        APP_DELEGATE?.window?.rootViewController = navVC
                        if businessId == 0 {
                            let vc = TradeOrderDetailsViewController.loadFromNib()
                            vc.viewModel.setResponseId(value: quotationId)
                            navVC.pushViewController(vc, animated: true)
                        } else {
                            let vc = TradeSentQuotationHistoryViewController.loadFromNib()
                            navVC.pushViewController(vc, animated: true)
                        }
                    }
                    break
                case .NOTIFICATION_ORDER_CHAT:
                    if let sender_id = Int(userInfo[AnyHashable("sender_id")] as? String ?? ""),
                       let receiver_id = Int(userInfo[AnyHashable("receiver_id")] as? String ?? ""),
                       let name = userInfo[AnyHashable("name")] as? String
                    {
                        
                        var Id = 0
                        if let request_id = Int(userInfo[AnyHashable("request_id")] as? String ?? ""){
                            Id = request_id
                        }
                        let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
                        let navVC = UINavigationController(rootViewController: tabBar)
                        navVC.navigationBar.isHidden = true
                        tabBar.selectedIndex = 1
                            
                        var user = CustomerDetails(json: JSON((Any).self))
                        user.name = name
                        user.id = sender_id
                        
                        let chatVC = ChatViewController.loadFromNib()
                        chatVC.customerDetails = user
                        chatVC.requestId = Id
                        chatVC.fromNotification = true
                        CURRENT_NAVIGATION = navVC
                        APP_DELEGATE?.window?.rootViewController = navVC
                        navVC.pushViewController(chatVC, animated: true)
                    }
                    break
            //MARK: Driver
                case .NOTIFICATION_DRIVER_VERIFICATION,
                     .NOTIFICATION_DRIVER_ORDER_REQUEST,
                    .NOTIFICATION_WEEKLY_PAYMENT,
                    .NOTIFICATION_PAYMENT_REQUEST_STATUS:
                    break
            //MARK: Customer Notifications
                case .NOTIFICATION_ORDER_STATUS_CHANGE,
                     .NOTIFICATION_ORDER_RECEIPT_UPLOADED,
                     .NOTIFICATION_EARN_POINT,
                     .NOTIFICATION_PAYMENT_REQUEST,
                     .NOTIFICATION_TRADE_CONFIRM_QUOTATION,
                     .NOTIFICATION_TRADE_REQUEST_CANCELLED,
                     .NOTIFICATION_TRADE_REQUEST_COMPLETED,
                     .NOTIFICATION_SHOP_BROADCAST_MESSAGE,
                     .NOTIFICATION_TRADE_SERVICE_EXTRA_CHARGES,
                     .NOTIFICATION_CASH_PAYMENT_CONFIRMED:
                    break
                }
            }
        }
        
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
