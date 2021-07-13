//
//  NotificationsViewController.swift
//  GoLocal
//
//  Created by C100-104on 27/12/20.
//

import UIKit
import SwiftyJSON
class NotificationsViewController: UIViewController {

    @IBOutlet weak var lblNoMsg : UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var vwNav: UIView!
    @IBOutlet weak var tableView: UITableView!
    var dataSource: NotificationDataSource?
    var viewModel =  NotificationViewModel()
    var isLoader : Bool = false
    let refresher = UIRefreshControl()
    //Load more
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var offset = 0
    var isLoadMore:Bool = false
    var isFromProfile = false
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = NotificationDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.tableFooterView = UIView()
        self.vwNav.addBottomShadow()
        self.btnBack.isHidden = !isFromProfile
        isLoader = true
        getNotification(offset: offset)
        refresher.addTarget(self, action: #selector(initialRequest(_:)), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    // For Pull to Referesh
    @objc private func initialRequest(_ sender: Any) {
        tableView.refreshControl = refresher
        isLoader = false
        self.offset = 0
        getNotification(offset: offset)
    }
    
    func loadMoreRequest() {      
        offset = offset + 1
        isLoader = false
        getNotification(offset: offset)
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func actionGoToDifferentScreens(_ sender: UIButton) {
        let notification = viewModel.getNotification(at: sender.tag)
        let typeId = notification.notificationTypeId ?? 0
        let notificationType  : NOTIFICATION_TYPE = NOTIFICATION_TYPE(rawValue: typeId) ?? .NOTIFICATION_ORDER_STATUS_CHANGE
        
        switch notificationType {
        case .NOTIFICATION_SHOP_ORDER_REQUEST:
            if let order_id = notification.dataId ,order_id != 0{
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
            if let response_id = notification.dataId {
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
            if let response_id = notification.dataId {
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
            if let response_id = notification.dataId {
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
            if let response_id = notification.dataId {
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
            if let quotationId = notification.dataId
            {
                let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
                tabBar.selectedIndex = 1
                let navVC = UINavigationController(rootViewController: tabBar)
                navVC.navigationBar.isHidden = true
                APP_DELEGATE?.window?.rootViewController = navVC
                
                let vc = TradeOrderDetailsViewController.loadFromNib()
                vc.viewModel.setResponseId(value: quotationId)
                navVC.pushViewController(vc, animated: true)
                
            }
            break
        case .NOTIFICATION_ORDER_CHAT:
            if let request_id = notification.dataId
            {
                
                let tabBar = MainTabBarController(nibName: "MainTabBarController", bundle: nil)
                let navVC = UINavigationController(rootViewController: tabBar)
                navVC.navigationBar.isHidden = true
                tabBar.selectedIndex = 1
                    
                let vc = TradeOrderDetailsViewController.loadFromNib()
                vc.viewModel.setResponseId(value: request_id)
                CURRENT_NAVIGATION = navVC
                APP_DELEGATE?.window?.rootViewController = navVC
                navVC.pushViewController(vc, animated: true)
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
