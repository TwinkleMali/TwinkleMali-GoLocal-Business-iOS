//
//  ForgotPasswordViewController.swift
//  GoLocal
//
//  Created by C100-104on 17/12/20.
//

import UIKit
import IQKeyboardManagerSwift
import NotificationBannerSwift
class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    var activityIndicator: UIActivityIndicatorView? {
        get{
            if let cell = tableView.cellForRow(at: IndexPath(row: ForgotPasswordField.submitButton.rawValue, section: 0)) as? CommonButtonTVCell{
                return cell.activityIndicator
            }
            return nil
        }
    }
    //MARK:- VARIABLES
    var dataSource: ForgotPasswordViewDataSource?
    var viewModel = ForgotPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 45
        mainView.clipsToBounds = true
        self.dataSource = ForgotPasswordViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        tableView.delegate = self.dataSource
        tableView.dataSource = self.dataSource
       
    }
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        navigationController?.navigationBar.barStyle = .blackOpaque
    }
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        navigationController?.navigationBar.barStyle = .default
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func doForgotPassword(_ sender : UIButton) {
        if let cell = tableView.cellForRow(at: IndexPath(row: ForgotPasswordField.email.rawValue, section: 0)) as? CommonTextFieldTVCell{
            cell.textField.resignFirstResponder()
        }
        if validation() {
         doForgotPassword()
        }
    }
    
    func validation() -> Bool {
        guard let email = self.viewModel.getEmail() else {
            let banner = NotificationBanner(title: BannerTitle.validation.rawValue, subtitle: validationMethod.getEnterValidDataMessage(.validInformation), leftView: nil, rightView: nil, style: .danger)
            banner.delegate = self
            banner.show()
            return false
        }
        if !(email.isEmail) {
            let banner = NotificationBanner(title: BannerTitle.validation.rawValue, subtitle: validationMethod.getEnterValidDataMessage(.emailAddress), leftView: nil, rightView: nil, style: .danger)
            banner.delegate = self
            banner.show()
            return false
        }
        return true
    }
}
