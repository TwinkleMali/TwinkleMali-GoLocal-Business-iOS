//
//  ForgotPasswordDataSource.swift
//  GoLocal
//
//  Created by C100-104on 17/12/20.
//

import Foundation
import UIKit
class ForgotPasswordViewDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: ForgotPasswordViewModel
    private let viewController: UIViewController
    private var forgotPasswordViewController : ForgotPasswordViewController? {
        get{
            viewController as? ForgotPasswordViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: ForgotPasswordViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("CommonTextFieldTVCell")
        tableView.register("CommonButtonTVCell")
    }
}
extension ForgotPasswordViewDataSource :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case ForgotPasswordField.email.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.textField.becomeFirstResponder()
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.textField.delegate = self
                cell.textField.text = self.viewModel.getEmail()
                cell.textField.keyboardType = .default
                cell.textField.returnKeyType = .done
                cell.textField.autocorrectionType = .no
                cell.textField.textContentType = .emailAddress
                cell.imgIcon.image = #imageLiteral(resourceName: "icon_email")
                return cell
            }
        case ForgotPasswordField.submitButton.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVCell", for: indexPath) as? CommonButtonTVCell{
                cell.selectionStyle = .none
                cell.btnSubmit.setTitle("Send Now", for: .normal)
                cell.btnSubmit.addTarget(self.forgotPasswordViewController, action: #selector(self.forgotPasswordViewController?.doForgotPassword(_:)), for: .touchUpInside)
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
}

extension ForgotPasswordViewDataSource : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.tableView.isScrollEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.tableView.isScrollEnabled = true
        self.viewModel.setEmail(email: textField.text ?? "")
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
