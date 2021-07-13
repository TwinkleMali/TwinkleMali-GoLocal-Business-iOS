//
//  BusinessNotificationViewController.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 17/06/21.
//

import UIKit
import IQKeyboardManagerSwift

class BusinessNotificationViewController: BaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var btnShowSendView: UIButton!
    @IBOutlet weak var textFiledNotificationTitle: UITextField!
    @IBOutlet weak var textViewNotificationMessage: IQTextView!
    @IBOutlet weak var viewSendNotification: UIView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    
    
    var isForSendPush = false
    var viewModel = BusinessNotificationViewModel()
    var dataSource : BusinessNotificationViewDataSource?
    var isScrolling = false
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = BusinessNotificationViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        self.SetUpView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if !isForSendPush {
            self.getNotificationHistory()
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        self.back(withAnimation: true)
    }
    
    @IBAction func actionSendNotification(_ sender: UIButton) {
        if sender.tag == 20 {
            let vc = BusinessNotificationViewController.loadFromNib()
            vc.isForSendPush = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if validation() {
                self.sendPostNotification(titleText: self.textFiledNotificationTitle.text ?? "", messageText: self.textViewNotificationMessage.text)
            }
        }
    }
    
    func SetUpView(){
        self.viewSendNotification.isHidden = !isForSendPush
        self.tableView.isHidden = isForSendPush
        self.lblNoData.isHidden = isForSendPush
        self.lblTitle.text = isForSendPush ? "Send Notification" : "Business Notifications"
        if isForSendPush {
            
        } else {
            
        }
    }
    func validation() -> Bool {
        if self.textFiledNotificationTitle.text?.isEmpty ?? false && self.textViewNotificationMessage.text.isEmpty {
            self.showBanner(bannerTitle: .validation, message: "Please add details", type: .warning)
            return false
        } else if self.textFiledNotificationTitle.text?.count ?? 0 < 4{
            self.showBanner(bannerTitle: .validation, message: "Please add valid notification", type: .warning)
            return false
        } else if self.textViewNotificationMessage.text?.count ?? 0 < 4 {
            self.showBanner(bannerTitle: .validation, message: "Please add valid message. ", type: .warning)
            return false
        }
        return true
    }
}
