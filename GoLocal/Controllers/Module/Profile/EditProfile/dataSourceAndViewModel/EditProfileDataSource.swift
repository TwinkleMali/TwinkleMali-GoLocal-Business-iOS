//
//  EditProfileDataSource.swift
//  GoLocalDriver
//
//  Created by C100-142 on 20/01/21.
//

import Foundation
import UIKit

class EditProfileDataSource: NSObject {
    
    private var tableView : UITableView
    private var viewModel : LoginViewModel
    private var viewController : UIViewController
    private var editProfileViewController : EditProfileViewController?{
        get{
            viewController as? EditProfileViewController
        }
    }
    
    init(tableView: UITableView, viewModel: LoginViewModel, viewController: UIViewController){
        self.tableView = tableView
        self.viewController = viewController
        self.viewModel = viewModel
        tableView.register("CommonTextFieldTVCell")
        tableView.register("CommonButtonTVCell")
    }
    
}
extension EditProfileDataSource: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileField.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case EditProfileField.firstname.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "First name"
                cell.imgIcon.image = #imageLiteral(resourceName: "profile_icon")
                cell.textField.text = viewModel.getFirstname()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                return cell
            }
            
        case EditProfileField.lastname.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Last name"
                cell.imgIcon.image = #imageLiteral(resourceName: "profile_icon")
                cell.textField.text = viewModel.getLastname()
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                return cell
            }
            
        case EditProfileField.email.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Email"
                cell.imgIcon.image = #imageLiteral(resourceName: "icon_email")
                cell.textField.text = viewModel.getEmail()
                cell.textField.delegate = self
                cell.textField.isUserInteractionEnabled = false
//                cell.textField.textColor = UIColor.init(named: "LightGreyColor")
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                
                return cell
            }
            
        case EditProfileField.phoneNumber.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldTVCell", for: indexPath) as? CommonTextFieldTVCell{
                cell.selectionStyle = .none
                cell.bottomView.isHidden = true
                cell.btnHidePassword.isHidden = true
                cell.textField.isSecureTextEntry = false
                cell.lblTitle.text = "Phone Number"
                cell.imgIcon.image = #imageLiteral(resourceName: "icon_phone")
                cell.textField.isUserInteractionEnabled = false
//                cell.textField.textColor = UIColor.init(named: "LightGreyColor")
                cell.textField.text = "+\(USER_DETAILS?.countryCode ?? 0) \(viewModel.getPhonenum() ?? "")"
                cell.textField.delegate = self
                cell.textField.returnKeyType = .next
                cell.textField.tag = indexPath.row
                return cell
            }

        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    
}
extension EditProfileDataSource : UITextFieldDelegate {
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text.asStringOrEmpty())
        
        switch textField.tag {
        case EditProfileField.firstname.rawValue:
            self.viewModel.setFirstname(value: textField.text.asStringOrEmpty())
            break
            
        case EditProfileField.lastname.rawValue:
            self.viewModel.setLastname(value: textField.text.asStringOrEmpty())
            break
            
        case EditProfileField.email.rawValue:
            self.viewModel.setEmail(value: textField.text.asStringOrEmpty())
            break
            
        case EditProfileField.phoneNumber.rawValue:
            self.viewModel.setPhonenum(value: textField.text.asStringOrEmpty())
            break
            
        default:
            break
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
