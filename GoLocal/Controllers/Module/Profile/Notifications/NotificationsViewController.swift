//
//  NotificationsViewController.swift
//  GoLocal
//
//  Created by C100-104on 27/12/20.
//

import UIKit

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
        let vc = OrderDetailsViewController(nibName: "OrderDetailsViewController", bundle: .main)
        vc.isOrderRequest = false
        vc.orderId = viewModel.getNotification(at: sender.tag).id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
