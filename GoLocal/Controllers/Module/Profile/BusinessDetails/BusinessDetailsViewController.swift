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
    let datePicker = UIDatePicker()
    let toolBar = UIToolbar()
    
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
                editBusinessDetails()
            }
        }else {
            isEditEnable = true
            btnEdit.setTitle("Save", for: .normal)
            tableView.reloadData()
        }
    }
    
    @IBAction func actionDatePicker(_ sender: UIButton){
        
       
    }
    
    //MARK: -   DatePicker Methods
    func showDatePicker(textfield : UITextField){
            //Formate Date
        datePicker.datePickerMode = .time
        datePicker.accessibilityLabel = textfield.accessibilityLabel        
        datePicker.tag = textfield.tag
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
            datePicker.minimumDate = Date()
            //ToolBar
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDatePicker));
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textfield.inputAccessoryView = toolbar
            textfield.inputView = datePicker
    }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func handleDatePicker() {
        var arrSchedule : [Schedule] = viewModel.getShopSchedule()
        var objTime : Schedule = arrSchedule[datePicker.tag]
       
//      let indexpath : IndexPath = IndexPath(row: datePicker.tag, section: BusinessDetailField.OpenCloseTime.rawValue)
//      let cell = tableView.cellForRow(at: indexpath) as! BusinessDetailsTVCell

        if datePicker.accessibilityLabel == "OpenTime"{
            objTime.openingTime = datePicker.date.toString().toDateString(outputFormat: TIME_FORMATE)
            
        }else if datePicker.accessibilityLabel == "CloseTime"{
            objTime.closingTime = datePicker.date.toString().toDateString(outputFormat: TIME_FORMATE)
        }
        arrSchedule.remove(at: datePicker.tag)
        arrSchedule.insert(objTime, at: datePicker.tag)
        viewModel.setShopSchedule(shopSchedule: arrSchedule)
        tableView.reloadRows(at: [IndexPath(row: datePicker.tag, section: BusinessDetailField.OpenCloseTime.rawValue)], with: .none)
    }
    
    @objc func btnRadioClick(_ sender: UIButton) {
        if sender.tag == 1{
            viewModel.setDeliveryType(deliveryType: DeliveryType.delivery.rawValue)
        }else  if sender.tag == 2{
            viewModel.setDeliveryType(deliveryType: DeliveryType.collection.rawValue)
        }else if sender.tag == 3{
            viewModel.setDeliveryType(deliveryType: DeliveryType.both.rawValue)
        }
        tableView.reloadRows(at: [IndexPath(row: 0, section: BusinessDetailField.DeliveryType.rawValue)], with: .none)
    }
    
    @objc func btnTimeSwitchClick(_ sender: UIButton) {
        var objTime : Schedule = viewModel.getShopSchedule()[sender.tag]
        
        let indexpath : IndexPath = IndexPath(row: datePicker.tag, section: BusinessDetailField.OpenCloseTime.rawValue)
        let cell = tableView.cellForRow(at: indexpath) as! BusinessDetailsTVCell
        if cell.btnSwitch.currentImage == UIImage(named: "switch_off"){
            objTime.isClosed = 0
            cell.btnSwitch.setImage(UIImage(named: "switch_on"), for: .normal)
        }else {
            objTime.isClosed = 1
            cell.btnSwitch.setImage(UIImage(named: "switch_off"), for: .normal)
        }
        tableView.reloadRows(at: [IndexPath(row: datePicker.tag, section: BusinessDetailField.OpenCloseTime.rawValue)], with: .automatic)
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

