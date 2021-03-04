//
//  AddBankAccountDataSource.swift
//  GoLocalDriver
//
//  Created by C100-142 on 21/01/21.
//

import Foundation
import UIKit

class AddBankAccountDataSource: NSObject {
    
    private var tableView : UITableView
    private var viewModel : AddBankAccountViewModel
    private var viewController : UIViewController
    private var addBankAccountViewController : AddBankAccountViewController?{
        get{
            viewController as? AddBankAccountViewController
        }
    }
    
    init(tableView: UITableView,viewModel: AddBankAccountViewModel, viewController: UIViewController){
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("AddAccountTextFieldTVCell")
        tableView.register("CommonButtonTVCell")
    }
}
extension AddBankAccountDataSource: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case AddAccountField.bankName.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddAccountTextFieldTVCell") as? AddAccountTextFieldTVCell {
                cell.lblTitle.text = "Bank Name"
                cell.textField.isUserInteractionEnabled = false
                cell.textField.text = ""//set prdefine values from viewModel
                cell.accountTypeView.isHidden = true
                cell.btnSelection.isHidden = false
                cell.btnSelection.addTarget(self.addBankAccountViewController, action: #selector(self.addBankAccountViewController?.actionBankSelection(_:)), for: .touchUpInside)
                return cell
            }
        case AddAccountField.accountType.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddAccountTextFieldTVCell") as? AddAccountTextFieldTVCell {
                cell.lblTitle.text = "Account Type"
                cell.accountTypeView.isHidden = false
                cell.textField.text = ""
                cell.btnSelection.isHidden = true
                cell.btnSaving.addTarget(self.addBankAccountViewController, action: #selector(self.addBankAccountViewController?.actionAccountType(_:)), for: .touchUpInside)
                cell.btnCurrent.addTarget(self.addBankAccountViewController, action: #selector(self.addBankAccountViewController?.actionAccountType(_:)), for: .touchUpInside)
                return cell
            }
        case AddAccountField.accountNumber.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddAccountTextFieldTVCell") as? AddAccountTextFieldTVCell {
                cell.lblTitle.text = "Account Number"
                cell.btnSelection.isHidden = true
                cell.textField.text = ""//set prdefine values from viewModel
                cell.textField.delegate = self
                cell.textField.tag = indexPath.row
                cell.accountTypeView.isHidden = true
                return cell
            }
        case AddAccountField.ifscCode.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddAccountTextFieldTVCell") as? AddAccountTextFieldTVCell {
                cell.lblTitle.text = "IFSC Code"
                cell.btnSelection.isHidden = true
                cell.textField.text = ""//set prdefine values from viewModel
                cell.textField.delegate = self
                cell.textField.tag = indexPath.row
                cell.accountTypeView.isHidden = true
                return cell
            }
        case AddAccountField.otherDetails.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddAccountTextFieldTVCell") as? AddAccountTextFieldTVCell {
                cell.lblTitle.text = "Other Details"
                cell.btnSelection.isHidden = true
                cell.textField.text = ""//set prdefine values from viewModel
                cell.textField.delegate = self
                cell.textField.tag = indexPath.row
                cell.accountTypeView.isHidden = true
                return cell
            }
            
//        case AddAccountField.submitButton.rawValue:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVCell", for: indexPath) as? CommonButtonTVCell{
//                cell.selectionStyle = .none
//                cell.btnSubmit.setTitle("Add", for: .normal)
//                cell.btnSubmit.addTarget(self.addBankAccountViewController, action: #selector(self.addBankAccountViewController?.actionAddAccount(_:)), for: .touchUpInside)
//                return cell
//            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    
}
extension AddBankAccountDataSource : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 2:
            print(textField.text!)//self.viewModel.setEmail(value: textField.text ?? "")
        case 3:
            print(textField.text!)//self.viewModel.setEmail(value: textField.text ?? "")
        case 4:
            print(textField.text!)//self.viewModel.setEmail(value: textField.text ?? "")
        default:
            break
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
}

