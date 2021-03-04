//
//  LoginDataSource.swift
//  GoLocal
//
//  Created by C100-104on 17/12/20.
//

import Foundation
import UIKit
class LoginViewDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: LoginViewModel
    private let viewController: UIViewController
    private var loginViewController : LoginViewController? {
        get{
            viewController as? LoginViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: LoginViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("CommonTextFieldTVCell")
        tableView.register("CommonButtonTVCell")
    }
}
extension LoginViewDataSource :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case LoginField.email.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.textField.text = viewModel.getEmail()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = -10
                cell.imgIcon.image = #imageLiteral(resourceName: "icon_email")
                return cell
            }
        case LoginField.password.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = false
                cell.btnHidePassword.isHidden = false
                cell.textField.isSecureTextEntry = true
                cell.textField.delegate = self
                cell.lblTitle.text = "Password"
                cell.textField.text = viewModel.getPassword()
                cell.textField.returnKeyType = .done
                cell.imgIcon.image = #imageLiteral(resourceName: "icon_lock")
                cell.textField.tag = -20
                cell.textField.setRightPadding(40)
                cell.btnRememberMe.isSelected = self.loginViewController?.isRemember ?? false
                cell.btnForgotPassword.addTarget(self.loginViewController, action: #selector(self.loginViewController?.actionForgotPassword(_:)), for: .touchUpInside)
                cell.btnRememberMe.addTarget(self.loginViewController, action: #selector(self.loginViewController?.actionRememberMe(_:)), for: .touchUpInside)
                return cell
            }
        case LoginField.loginButton.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVCell", for: indexPath) as? CommonButtonTVCell{
                cell.selectionStyle = .none
                cell.btnSubmit.setTitle("Login", for: .normal)
                cell.btnSubmit.addTarget(self.loginViewController, action: #selector(self.loginViewController?.actionDoLogin(_:)), for: .touchUpInside)
                return cell
            }
       
        default:
            break
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
//MARK:- TextField Delegate
extension LoginViewDataSource : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.tableView.isScrollEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.tableView.isScrollEnabled = true
        if textField.tag == -10 {
            self.viewModel.setEmail(value: textField.text ?? "")
        } else {
            self.viewModel.setPassword(value: textField.text ?? "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == -10 {
            self.viewModel.setEmail(value: textField.text ?? "")
            if let cell = loginViewController?.tableView.cellForRow(at: IndexPath(row: LoginField.password.rawValue, section: 0)) as? CommonTextFieldTVCell {
                cell.textField.becomeFirstResponder()
            }
        } else {
            self.viewModel.setPassword(value: textField.text ?? "")
            textField.resignFirstResponder()
        }
        return false
    }
}
