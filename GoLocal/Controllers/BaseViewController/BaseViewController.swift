//
//  BaseViewController.swift
//  GoLocal
//
//  Created by C100-104 on 24/12/20.
//

import UIKit
import Reachability
import NotificationBannerSwift
import AVFoundation
var BASEVIEW_CONTROLLER : BaseViewController?
var CURRENT_NAVIGATION : UINavigationController?

class BaseViewController: UIViewController {
    //MARK:- VARIABLES
    
    var reachability : Reachability?
    var bannerIsVisible = false
    var objOrderReq : OrderRequests!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        if BASEVIEW_CONTROLLER == nil {
            BASEVIEW_CONTROLLER = self
        }
        do
        {
            reachability =  try Reachability()
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
//        notificationCenterObservers()
        checkRechabiliy()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
    } 

    
    func back(withAnimation : Bool)  {
        self.navigationController?.popViewController(animated: withAnimation)
    }
    
    func isTabbarHidden(_ isHidden:Bool) {
        self.tabBarController?.tabBar.isHidden = isHidden
    }
    
    func UpdateTabBar(index : Int)
    {
        self.tabBarController?.selectedIndex = index
    }
    
    func hideTabBar() {
        let tabFrame = self.tabBarController?.tabBar.frame
        //tabFrame?.origin.y = self.view.frame.size.height + (tabFrame?.size.height)!
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height + (tabFrame?.size.height)!
        })
    }
    func requestCameraPermission() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                //self.setupCaptureSession()
                return true
            case .notDetermined: // The user has not yet been asked for camera access.
                var isGranted  = false
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    isGranted = granted
                }
                return isGranted
            case .denied: // The user has previously denied access.
                return false

            case .restricted: // The user can't grant access due to restrictions.
                return false
        }
    }
    func alertPromptToAllowCameraAccessViaSetting() {

        
            let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
         
             let alert = UIAlertController(
                 title: "Need Camera Access",
                 message: "Camera access is required to make full use of this app.",
                preferredStyle: UIAlertController.Style.alert
             )
         
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }))
        
            present(alert, animated: true, completion: nil)
       
    }
    func showTabBar() {
        let frame = self.tabBarController?.tabBar.frame
        //frame?.origin.y = self.view.frame.size.height - (frame?.size.height)!
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - (frame?.size.height)!
        })
    }
   
    //MARK:- Check Network Reachability
       func checkRechabiliy()
       {
           print("Check Reachability...")
           reachability?.whenReachable = { reachability in
               if reachability.connection == .wifi {
                   print("Reachable via WiFi")
                   isNetworkConnected =  true
               } else {
                   print("Reachable via Cellular")
                   isNetworkConnected =  true
               }
           }
           reachability?.whenUnreachable = { _ in
               print("Not reachable")
               isNetworkConnected = false
               /*let alert = UIAlertController(title: "Alert", message: "Please check your internet connection.", preferredStyle: .alert)
                NotificationCenter.default.addObserver(alert, selector: Selector(("hideAlertController")), name: NSNotification.Name(rawValue: "DismissAllAlertsNotification"), object: nil)
                self.present(alert, animated: true, completion:nil)*/
               //self.showAlert(title: "Alert", message: "Please check your internet connection.")
            self.showBanner(bannerTitle: .alert, message: "Please check your internet connection.", type: .warning)
           }
           
           do {
               try reachability?.startNotifier()
           } catch {
               print("Unable to start notifier")
           }
       }
    public func setupRootTabBarViewController(tabIndex: Int) {
        let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
        tabBar.selectedIndex = tabIndex
        let navVC = UINavigationController(rootViewController: tabBar)
        navVC.navigationBar.isHidden = true
        APP_DELEGATE?.window?.rootViewController = navVC

    }
    func navigateToHome(){
        let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
        let navVC = UINavigationController(rootViewController: tabBar)
        navVC.navigationBar.isHidden = true
        APP_DELEGATE?.window?.rootViewController = navVC
    }
    
    func showBanner(bannerTitle : BannerTitle , message : String, type : BannerStyle){
        //let imageView = UIImageView(image: UIImage(named: "warning_icon"))
        if !bannerIsVisible {
            NotificationBannerQueue.default.removeAll()
//            let titleFont = UIFont(name: "Montserrat-SemiBold", size: calculateFontForWidth(size: 15.0)) ?? nil
//            let subtitleFont = UIFont(name: "Montserrat-Medium", size: calculateFontForWidth(size: 15.0)) ?? nil
            //let edge = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
            let banner = NotificationBanner(title: bannerTitle.rawValue, subtitle: message, leftView: nil, rightView: nil, style: type)
            banner.delegate = self
            banner.show()
            //let banner = FloatingNotificationBanner(title: bannerTitle.rawValue, subtitle: message, titleFont: titleFont , titleColor: .white, titleTextAlign: nil, subtitleFont: subtitleFont, subtitleColor: .white, subtitleTextAlign: nil, leftView: nil, rightView: nil, style: type, colors: nil, iconPosition: .top)
            //banner.delegate = self
            //banner.show(queuePosition: .front, bannerPosition: .top, queue: .default, on: self, edgeInsets: edge, cornerRadius: 10, shadowColor: .black, shadowOpacity: 1.0, shadowBlurRadius: 10, shadowCornerRadius: 10, shadowOffset: UIOffset(horizontal: 0, vertical: 5), shadowEdgeInsets: nil)
        }
    }
    
    func openSettingApp(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Go to settings", style: .default, handler: {_ in
          UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        let closeAction = UIAlertAction(title: "Close", style: .destructive, handler: {_ in
            //self.enableLocation()
        })
        alert.addAction(okAction)
        alert.addAction(closeAction)
        present(alert, animated: true, completion: nil)
    }
}
//MARK:- NOTIFICATION BANNER DELEGATE
extension BaseViewController : NotificationBannerDelegate {
    func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
        bannerIsVisible = true
    }
    
    func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
        bannerIsVisible = true
    }
    
    func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) {
        bannerIsVisible = false
    }
    
    func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {
        
    }
}


