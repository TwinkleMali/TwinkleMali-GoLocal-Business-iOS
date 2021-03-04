//
//  NotificationDataSource.swift
//  GoLocalDriver
//
//  Created by C100-142 on 12/01/21.
//

import Foundation
import UIKit

class NotificationDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: NotificationViewModel
    private let viewController: UIViewController
    private var notificationViewController : NotificationsViewController? {
        get{
            viewController as? NotificationsViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: NotificationViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("NotificationTVCell")
        
    }
}
extension NotificationDataSource: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.getNotificationCount() > 0{
            self.notificationViewController?.lblNoMsg.isHidden = true
            tableView.isHidden = false
        }else {
            self.notificationViewController?.lblNoMsg.isHidden = false
            tableView.isHidden = true
        }
        return viewModel.getNotificationCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVCell", for: indexPath) as? NotificationTVCell{
            cell.selectionStyle = .none
            cell.lblNotificationTitle.text = self.viewModel.getNotification(at: indexPath.row).notificationMessage.asStringOrEmpty()
            cell.lblNotificationTime.text = self.viewModel.getNotification(at: indexPath.row).createdAt?.timeAgo()
            cell.btnNavigateToScreens.tag = indexPath.row
            cell.btnNavigateToScreens.addTarget(self.notificationViewController, action: #selector(self.notificationViewController?.actionGoToDifferentScreens(_:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidEndDecelerating(_ scrollView : UIScrollView) {
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            // Change 10.0 to adjust the distance from bottom
            if maximumOffset - currentOffset <= 10.0{
                if !self.notificationViewController!.isLoadMore{
                    self.notificationViewController?.indicatorView.isHidden = false
                    self.notificationViewController?.activityIndicator.startAnimating()
                    self.notificationViewController?.loadMoreRequest()
                    self.notificationViewController?.isLoadMore = true
                }
            }
    }
    
}
