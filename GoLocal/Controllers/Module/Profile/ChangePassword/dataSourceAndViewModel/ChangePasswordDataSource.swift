//
//  ChangePasswordDataSource.swift
//  GoLocalDriver
//
//  Created by C100-142 on 20/01/21.
//

import Foundation
import UIKit

class ChangePasswordDataSource: NSObject {
    
    private var tableView : UITableView
    private var viewModel : ChangePasswordViewModel
    private var viewController : UIViewController
    private var changePasswordViewController : ChangePasswordViewController?{
        get{
            viewController as? ChangePasswordViewController
        }
    }
    init(tableView: UITableView,viewModel: ChangePasswordViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewController = viewController
        self.viewModel = viewModel
        tableView.register("CommonTextFieldTVCell")
        tableView.register("CommonButtonTVCell")
    }
    
}
extension ChangePasswordDataSource: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChangePasswordField.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case ChangePasswordField.currentPassword.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = false
                cell.textField.isSecureTextEntry = true
                cell.lblTitle.text = "Current Password"
                cell.imgIcon.isHidden = true
                cell.imgIconWidthConstraint.constant = 0
                cell.textField.text = ""//viewModel.getEmail()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
        case ChangePasswordField.newPassword.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = false
                cell.textField.isSecureTextEntry = true
                cell.lblTitle.text = "New Password"
                cell.imgIcon.isHidden = true
                cell.imgIconWidthConstraint.constant = 0
                cell.textField.text = ""//viewModel.getEmail()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
        case ChangePasswordField.confirmPassword.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = false
                cell.textField.isSecureTextEntry = true
                cell.lblTitle.text = "Confirm Password"
                cell.imgIcon.isHidden = true
                cell.imgIconWidthConstraint.constant = 0
                cell.textField.text = ""//viewModel.getEmail()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
//        case ChangePasswordField.submitButton.rawValue:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVCell", for: indexPath) as? CommonButtonTVCell{
//                cell.selectionStyle = .none
//                cell.btnSubmit.setTitle("Save", for: .normal)
//                cell.btnSubmit.addTarget(self.changePasswordViewController, action: #selector(self.changePasswordViewController?.actionChangePassword(_:)), for: .touchUpInside)
//                return cell
//            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}


extension ChangePasswordDataSource : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text.asStringOrEmpty())
        switch textField.tag {
        case ChangePasswordField.currentPassword.rawValue:
            self.viewModel.setCurrentPwd(value: textField.text ?? "")
            
        case ChangePasswordField.newPassword.rawValue:
            self.viewModel.setNewPwd(value: textField.text ?? "")
        
        case ChangePasswordField.confirmPassword.rawValue:
            self.viewModel.setConfirmPwd(value: textField.text ?? "")
        
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

