//
//  BusinessDetailsViewController.swift
//  GoLocal
//
//  Created by C110 on 1/2/21.
//

import UIKit

class BusinessDetailsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    var dataSource: BusinessDetailsDataSource?
    var viewModel = BusinessDetailsViewModel()
    var isEditEnable : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = BusinessDetailsDataSource(tableView: tableView, viewModel: viewModel, viewController: self)

        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        self.getBusinessDetails()
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionEdit(_ sender: UIButton){
        if isEditEnable{
            isEditEnable = false
            btnEdit.setTitle("Edit Detail", for: .normal)
            tableView.reloadData()
            if validate() {
//                let  param : [String : Any] = [
//                    "user_id": USER_DETAILS?.id ?? 0,
//                    "shop_id": USER_DETAILS?.id ?? 0,
//                    "shop_name" : USER_DETAILS?.username.asStringOrEmpty() ?? "",
//                    "shop_address" : USER_DETAILS?.zipcode.asStringOrEmpty() ?? "",
//                    "latitude" : "",
//                    "longitude" : "",
//                    "email":"",
//                    "website":"",
//                    "country_id":"",
//                    "phone":"",
//                    "delivery_type":"",
//                    "licence_number":"",
//                    "shop_schedule":"",
//                    "delete_slider_image_ids":"",
//                    "slider_image":""
//                ]
//                editBusinessDetails(param: param)
            }
        }else {
            isEditEnable = true
            btnEdit.setTitle("Save", for: .normal)
            tableView.reloadData()
        }
    }
    
    func validate() -> Bool{
        if let storeNameCell = tableView.cellForRow(at: IndexPath(row: BusinessDetailField.StoreName.rawValue, section: 0)) as? CommonTextFieldTVCell {
            storeNameCell.textField.resignFirstResponder()
        }

        if let storeLocationCell = tableView.cellForRow(at: IndexPath(row: BusinessDetailField.StoreLocation.rawValue, section: 0)) as? CommonTextFieldTVCell {
            storeLocationCell.textField.resignFirstResponder()
        }
        
        if let emailCell = tableView.cellForRow(at: IndexPath(row: BusinessDetailField.Email.rawValue, section: 0)) as? CommonTextFieldTVCell {
            emailCell.textField.resignFirstResponder()
        }
        
        if let contactNumCell = tableView.cellForRow(at: IndexPath(row: BusinessDetailField.ContactNumber.rawValue, section: 0)) as? CommonTextFieldTVCell {
            contactNumCell.textField.resignFirstResponder()
        }
        
        if let websiteCell = tableView.cellForRow(at: IndexPath(row: BusinessDetailField.Website.rawValue, section: 0)) as? CommonTextFieldTVCell {
            websiteCell.textField.resignFirstResponder()
        }
        
        if let licenseNumCell = tableView.cellForRow(at: IndexPath(row: BusinessDetailField.LicenseNumber.rawValue, section: 0)) as? CommonTextFieldTVCell {
            licenseNumCell.textField.resignFirstResponder()
        }

//        var strMessage : String = ""
//        if viewModel.getFirstname() == nil || viewModel.getLastname() == nil{
//            strMessage = "Please fill details"
//        }else {
//            return true
//        }
//        self.showBanner(bannerTitle: .none, message: strMessage, type: .danger)
        return false
    }
    
}

