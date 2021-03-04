//
//  EditProfileViewController.swift
//  GoLocalDriver
//
//  Created by C100-142 on 20/01/21.
//

import UIKit

class EditProfileViewController: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var vwNav: UIView!
    var isEditEnable : Bool = false
    var viewModel = LoginViewModel()
    var dataSource: EditProfileDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = EditProfileDataSource(tableView: tableView,viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.tableFooterView = UIView()
        self.isEditEnable = false
        self.tableView.isUserInteractionEnabled = false
        self.vwNav.addBottomShadow()
    }
    
    @IBAction func btnback(_ sender: UIButton) {
        if isEditEnable{
            isEditEnable = false
            tableView.isUserInteractionEnabled = false
            btnEdit.setTitle("Edit Information", for: .normal)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func actionEdit(_ sender: UIButton){
        if isEditEnable{
            isEditEnable = false
            tableView.isUserInteractionEnabled = false
            btnEdit.setTitle("Edit Information", for: .normal)
            if validate() {
                let  param : [String : Any] = [
                    "user_id": USER_DETAILS?.id ?? 0,
                    "user_name" : USER_DETAILS?.username.asStringOrEmpty() ?? "",
                    "postcode" : USER_DETAILS?.zipcode.asStringOrEmpty() ?? "",
                    "first_name" : viewModel.getFirstname().asStringOrEmpty(),
                    "last_name" : viewModel.getLastname().asStringOrEmpty()
                ]
                editProfileInfo(param: param)
            }
        }else {
            isEditEnable = true
            tableView.isUserInteractionEnabled = true
            btnEdit.setTitle("Save", for: .normal)
            tableView.reloadData()
        }
    }
    
    func validate() -> Bool{
        if let fnameCell = tableView.cellForRow(at: IndexPath(row: EditProfileField.firstname.rawValue, section: 0)) as? CommonTextFieldTVCell {
            fnameCell.textField.resignFirstResponder()
        }

        if let lnameCell = tableView.cellForRow(at: IndexPath(row: EditProfileField.lastname.rawValue, section: 0)) as? CommonTextFieldTVCell {
            lnameCell.textField.resignFirstResponder()
        }

        var strMessage : String = ""
        if viewModel.getFirstname() == nil || viewModel.getLastname() == nil{
            strMessage = "Please fill details"
        }else {
            return true
        }
        self.showBanner(bannerTitle: .none, message: strMessage, type: .danger)
        return false
    }
    
    
}
