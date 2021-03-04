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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK:- Window
    var window: UIWindow?
    
    //MARK:- Socket Handler Obj
    var socketIOHandler:SocketIOHandler?
    var socketHandlersAdded = false
    var arrOrderRequestMain : [OrderRequests] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // IQKEYBOARD
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        //LIGHT APP INTERFABE
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        //GOOGLE MAPS CONFIG
        GMSServices.provideAPIKey(GOOGLE_KEY)
        
        
        //CHECK USER STATUS
        checkScreenNavigation()
                    
        
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

