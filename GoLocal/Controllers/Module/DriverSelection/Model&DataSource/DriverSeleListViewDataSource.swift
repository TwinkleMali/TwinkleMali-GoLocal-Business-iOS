//
//  DriverSeleListViewDataSource.swift
//  GoLocal
//
//  //  Created by C110 on 20/01/21.
//

import Foundation
import UIKit
class DriverSeleListViewDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: DriverSeleListViewModel
    private let viewController: UIViewController
    private var driverSeleListViewController : DriverSeleListViewController? {
        get{
            viewController as? DriverSeleListViewController
        }
    }
    private var isViewDriver : Bool = false
    private var selectedIndex : IndexPath!
   

   
    init(tableView: UITableView, viewModel: DriverSeleListViewModel, viewController: UIViewController, isViewDriver: Bool) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        self.isViewDriver = isViewDriver
        self.tableView.register("SelectDriverTVCell")
        self.tableView.register("DriverSectionTVCell")
       
    }
   
}

extension DriverSeleListViewDataSource : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isViewDriver{
            return DriverType.Total.rawValue
        }else {
            if viewModel.getDriverRowCount() > 0{
                return 2
            }else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isViewDriver{
            return 2
        }else {
            switch section {
                case DriverType.GoLocalFirstDrivers.rawValue:
                    return 1
                    
                case DriverType.OwnDrivers.rawValue:
                    return self.viewModel.getDriverRowCount()
                    
                default:
                    return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DriverSectionTVCell") as? SelectDriverTVCell{
            switch section {
                case DriverType.GoLocalFirstDrivers.rawValue :
                    cell.lblTitle.text = "Go Local First Drivers"
                break
                
                case DriverType.OwnDrivers.rawValue :
                    cell.lblTitle.text = "Own Drivers"
                break
                    
                case DriverType.BusyDrivers.rawValue :
                    cell.lblTitle.text = "Busy Drivers"
                break
                    
                case DriverType.OfflineDrivers.rawValue :
                    cell.lblTitle.text = "Offline Drivers"
                break
                    
                default:
                break
            }
            
            cell.selectionStyle = .none
            return cell
            }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectDriverTVCell", for: indexPath) as? SelectDriverTVCell {
                cell.selectionStyle = .none
                cell.vwInput.isHidden = true
                cell.vwDisable.isHidden = true
                //cell.txtDeliveryTime.text = "\(driverSeleListViewController?.selectedMin ?? 0) Minutes"
                if selectedIndex != nil{
                    if self.selectedIndex.section == indexPath.section && self.selectedIndex.row  == indexPath.row{
                        cell.vwInput.isHidden = false
                        cell.btnEdit.setImage(UIImage(named:"driver_select_icon"), for: .normal)
//                        cell.txtDeliveryTime.text = "\(selectedMin.aIntOrEmpty()) Minutes"
                        cell.txtDeliveryTime.text = "\(driverSeleListViewController?.selectedMin ?? 0) Minutes"
                    }else {
                        cell.btnEdit.setImage(UIImage(named:"driver_unselect_icon"), for: .normal)
                    }
                }else {
                    cell.btnEdit.setImage(UIImage(named:"driver_unselect_icon"), for: .normal)
                }
                
                
                switch indexPath.section {
                    case DriverType.GoLocalFirstDrivers.rawValue:
                        cell.lblDriverName.text = "Use Go Local First Driver"
                        cell.lblDriverNumber.isHidden = true
                        cell.lblDeliveryTime.text = "Expected Pickup Time"
                        cell.txtDeliveryTime.delegate = self
                        cell.txtDeliveryTime.tag = indexPath.section
                        return cell
                        
                    case DriverType.OwnDrivers.rawValue:
                        let objDriver : Drivers = self.viewModel.getDriver(atPos: indexPath.row)
                        if objDriver.name != nil && objDriver.name.asStringOrEmpty().length > 0{
                            cell.lblDriverName.text = "\(objDriver.name.asStringOrEmpty()) \(objDriver.lname.asStringOrEmpty())"
                        }else if objDriver.username != "" && objDriver.username.asStringOrEmpty().length > 0{
                            cell.lblDriverName.text = "\(objDriver.username.asStringOrEmpty())"
                        }else {
                            let name = objDriver.email.asStringOrEmpty().components(separatedBy: "@")
                            cell.lblDriverName.text = "\(name[0] )"
                        }
        
                        if objDriver.phone != nil && objDriver.phone.asStringOrEmpty().length > 0{
                            cell.lblDriverNumber.text = "\(objDriver.phone.asStringOrEmpty())"
                        }else {
                            cell.lblDriverNumber.text = "No number"
                        }
//                        cell.lblDriverNumber.isHidden = true
                        cell.lblDeliveryTime.text = "Delivery Time"
                        cell.txtDeliveryTime.delegate = self                   
                        cell.txtDeliveryTime.tag = indexPath.section
                        return cell
                        
                    default:
                        return cell
                }
            }
            return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isViewDriver{
            switch indexPath.section {
                case DriverType.GoLocalFirstDrivers.rawValue:
                    return 55
                    
                default:
                    return 75
            }
        }else {
            switch indexPath.section {
                case DriverType.GoLocalFirstDrivers.rawValue:
                    if selectedIndex != nil && (self.selectedIndex.section  == indexPath.section && self.selectedIndex.row  == indexPath.row){
                        return 160
                    }else {
                        return 55
                    }
                    
                default:
                    if selectedIndex != nil && (self.selectedIndex.section  == indexPath.section && self.selectedIndex.row  == indexPath.row){
                        return 160
                    }else {
                        return 75
                    }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isViewDriver{
            let vc = DriverDetailsViewController(nibName: "DriverDetailsViewController", bundle: .main)
            self.viewController.navigationController?.pushViewController(vc, animated: true)
        }else {
            if indexPath.section == DriverType.GoLocalFirstDrivers.rawValue{
                driverSeleListViewController?.selectedDriverId = 0
            }else {
                driverSeleListViewController?.selectedDriverId = self.viewModel.getDriver(atPos: indexPath.row).id ?? 0
            }
            selectedIndex = indexPath
            tableView.reloadData()
        }
    }    
}

//MARK:- TextField Delegate
extension DriverSeleListViewDataSource : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        driverSeleListViewController?.showDatePicker(textfield: textField)
//        //delegate method
//        driverSeleListViewController?.datePickerView.isHidden = false
//        driverSeleListViewController?.datePickerView.tag = textField.tag
//        textField.inputView = driverSeleListViewController?.datePickerView
//        textField.inputAccessoryView = driverSeleListViewController?.toolBar
    }
}
