//
//  ChangePasswordViewController.swift
//  GoLocalDriver
//
//  Created by C100-142 on 20/01/21.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var vwNav: UIView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ChangePasswordViewModel()
    var dataSource : ChangePasswordDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ChangePasswordDataSource(tableView: tableView, viewModel: viewModel,viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.vwNav.addBottomShadow()
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionChangePassword(_ sender: UIButton){
        if validate() {
            let  param : [String : Any] = [
                "user_id": USER_DETAILS?.id ?? 0,
                "old_password" : viewModel.getCurrentPwd().asStringOrEmpty() ,
                "new_password" : viewModel.getNewPwd().asStringOrEmpty()
            ]
            changePassword(param:param)
        }
    }
    
    func validate() -> Bool{
        if let currentPwdCell = tableView.cellForRow(at: IndexPath(row: ChangePasswordField.currentPassword.rawValue, section: 0)) as? CommonTextFieldTVCell {
            currentPwdCell.textField.resignFirstResponder()
        }

        if let newPwdCell = tableView.cellForRow(at: IndexPath(row: ChangePasswordField.newPassword.rawValue, section: 0)) as? CommonTextFieldTVCell {
            newPwdCell.textField.resignFirstResponder()
        }

        if let confirmPwdCell = tableView.cellForRow(at: IndexPath(row: ChangePasswordField.confirmPassword.rawValue, section: 0)) as? CommonTextFieldTVCell {
            confirmPwdCell.textField.resignFirstResponder()
        }

        var strMessage : String = ""
        if viewModel.getCurrentPwd() == nil{
            strMessage = "Please Enter Current Password"
        }else if viewModel.getNewPwd() == nil{
            strMessage = "Please Enter New Password"
        }else if viewModel.getConfirmPwd() == nil {
            strMessage = "Please Enter Confirm Password"
        }else if  USER_DEFAULTS.value(forKey: defaultsKey.password.rawValue).asStringOrEmpty() != viewModel.getCurrentPwd(){
            strMessage = "Invalid Current Password"
        }else if viewModel.getNewPwd() != viewModel.getConfirmPwd(){
            strMessage = "Confirm password and New password should be matched or same"
        }else {
            return true
        }
        self.showBanner(bannerTitle: .none, message: strMessage, type: .danger)
        return false
    }
}
