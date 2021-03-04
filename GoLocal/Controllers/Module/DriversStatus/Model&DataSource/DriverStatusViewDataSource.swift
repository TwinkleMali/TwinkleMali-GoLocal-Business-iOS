//
//  DriverStatusViewDataSource.swift
//  GoLocal
//
//  //  Created by C110 on 20/01/21.
//

import Foundation
import UIKit
class DriverStatusViewDataSource: NSObject, UITextFieldDelegate {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: DriverStatusViewModel
    private let viewController: UIViewController
    private var driverStatusViewController : DriverStatusViewController? {
        get{
            viewController as? DriverStatusViewController
        }
    }
    
    private var selectedIndex : IndexPath!
   
    init(tableView: UITableView, viewModel: DriverStatusViewModel, viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        self.tableView.register("BusinessDriverTVCell")
        self.tableView.register("GoLocalDriverTVCell")
        self.tableView.register("DriverSectionTVCell")
        self.tableView.register("SelectDriverTVCell")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        driverStatusViewController?.showDatePicker(textfield: textField)
    }
}

//extension DriverStatusViewDataSource : UITableViewDataSource,UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return DriverType.Total.rawValue
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            switch section {
//                case DriverType.GoLocalFirstDrivers.rawValue:
//                    return 1
//
//                case DriverType.OwnDrivers.rawValue:
//                    return self.viewModel.getDriver().availableDrivers?.count ?? 0
//
//                case DriverType.BusyDrivers.rawValue:
//                    return self.viewModel.getDriver().busyDrivers?.count ?? 0
//
//                case DriverType.OfflineDrivers.rawValue:
//                    return self.viewModel.getDriver().offlineDrivers?.count ?? 0
//
//                default:
//                    return 0
//            }
//
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "DriverSectionTVCell") as? SelectDriverTVCell{
//            switch section {
//                case DriverType.GoLocalFirstDrivers.rawValue :
//                    cell.lblTitle.text = "Go Local First Drivers"
//                break
//
//                case DriverType.OwnDrivers.rawValue :
//                    cell.lblTitle.text = "Available Drivers"
//                break
//
//                case DriverType.BusyDrivers.rawValue :
//                    cell.lblTitle.text = "Busy Drivers"
//                break
//
//                case DriverType.OfflineDrivers.rawValue :
//                    cell.lblTitle.text = "Offline Drivers"
//                break
//
//                default:
//                break
//            }
//
//            cell.selectionStyle = .none
//            return cell
//            }
//
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let height : CGFloat = 40
//        switch section {
//            case DriverType.GoLocalFirstDrivers.rawValue :
//                return height
//
//            case DriverType.OwnDrivers.rawValue :
//                if (self.viewModel.getDriver().availableDrivers?.count ?? 0) > 0{
//                    return height
//                }else {
//                    return 0
//                }
//
//
//            case DriverType.BusyDrivers.rawValue :
//                if (self.viewModel.getDriver().busyDrivers?.count ?? 0) > 0{
//                    return height
//                }else {
//                    return 0
//                }
//
//            case DriverType.OfflineDrivers.rawValue :
//                if (self.viewModel.getDriver().offlineDrivers?.count ?? 0) > 0{
//                    return height
//                }else {
//                    return 0
//                }
//
//            default:
//                return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return 0.01
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.section == DriverType.GoLocalFirstDrivers.rawValue {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "GoLocalDriverTVCell", for: indexPath) as? GoLocalDriverTVCell {
//                cell.lblDriverName.text = "Use Go Local First Driver"
//                cell.btnEdit.setImage(UIImage(named:"driver_unselect_icon"), for: .normal)
//                return cell
//            }
//        }else {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessDriverTVCell", for: indexPath) as? BusinessDriverTVCell {
//                cell.vwDisable.isHidden = true
//                cell.isUserInteractionEnabled = true
//            var objDriver : Drivers!
//            if DriverType.OwnDrivers.rawValue == indexPath.section{
//                objDriver = self.viewModel.getDriver().availableDrivers?[indexPath.row]
//            }else if DriverType.BusyDrivers.rawValue == indexPath.section{
//                objDriver = self.viewModel.getDriver().busyDrivers?[indexPath.row]
//            }else if DriverType.OfflineDrivers.rawValue == indexPath.section{
//                objDriver = self.viewModel.getDriver().offlineDrivers?[indexPath.row]
//                cell.vwDisable.isHidden = false
//                cell.isUserInteractionEnabled = false
//            }
//
//                if objDriver != nil{
//                    cell.btnEdit.setImage(UIImage(named:"driver_unselect_icon"), for: .normal)
//                    if objDriver.name != nil && objDriver.name.asStringOrEmpty().length > 0{
//                        cell.lblDriverName.text = "\(objDriver.name.asStringOrEmpty()) \(objDriver.lname.asStringOrEmpty())"
//                    }else if objDriver.username != "" && objDriver.username.asStringOrEmpty().length > 0{
//                        cell.lblDriverName.text = "\(objDriver.username.asStringOrEmpty())"
//                    }else {
//                        let name = objDriver.email.asStringOrEmpty().components(separatedBy: "@")
//                            cell.lblDriverName.text = "\(name[0] )"
//                    }
//
//                    if objDriver.phone != nil && objDriver.phone.asStringOrEmpty().length > 0{
//                        cell.lblDriverNumber.text = "\(objDriver.phone.asStringOrEmpty())"
//                    }else {
//                        cell.lblDriverNumber.text = "No number"
//                    }
//                }
//                return cell
//            }
//        }
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if DriverType.BusyDrivers.rawValue == indexPath.section{
//            let vc = DriverDetailsViewController(nibName: "DriverDetailsViewController", bundle: .main)
//            vc.objDriver = self.viewModel.getDriver().busyDrivers?[indexPath.row]
//            self.viewController.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//}
//

extension DriverStatusViewDataSource : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DriverType.Total.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case DriverType.GoLocalFirstDrivers.rawValue:
                return 1

            case DriverType.OwnDrivers.rawValue:
                return self.viewModel.getDriver().availableDrivers?.count ?? 0

            case DriverType.BusyDrivers.rawValue:
                return self.viewModel.getDriver().busyDrivers?.count ?? 0

            case DriverType.OfflineDrivers.rawValue:
                return self.viewModel.getDriver().offlineDrivers?.count ?? 0

            default:
                return 0
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
                if selectedIndex != nil{
                    if self.selectedIndex.section == indexPath.section && self.selectedIndex.row  == indexPath.row{
                        cell.vwInput.isHidden = false
                        cell.btnEdit.setImage(UIImage(named:"driver_select_icon"), for: .normal)
//                        cell.txtDeliveryTime.text = "\(selectedMin.aIntOrEmpty()) Minutes"
                        cell.txtDeliveryTime.text = "\(driverStatusViewController?.selectedMin.aIntOrEmpty() ?? 0) Minutes"
                    }else {
                        cell.btnEdit.setImage(UIImage(named:"driver_unselect_icon"), for: .normal)
                    }
                }else {
                    cell.btnEdit.setImage(UIImage(named:"driver_unselect_icon"), for: .normal)
                }
                cell.vwDisable.isHidden = true
                if indexPath.section == DriverType.GoLocalFirstDrivers.rawValue{
                    cell.lblDriverName.text = "Use Go Local First Driver"
                    cell.lblDriverNumber.isHidden = true
                    cell.lblDeliveryTime.text = "Expected Pickup Time"
                    cell.txtDeliveryTime.delegate = self
                    cell.txtDeliveryTime.tag = indexPath.section
                    return cell
                }else {
                    cell.isUserInteractionEnabled = true
                    var objDriver : Drivers!
                    if DriverType.OwnDrivers.rawValue == indexPath.section{
                        objDriver = self.viewModel.getDriver().availableDrivers?[indexPath.row]
                        cell.lblDeliveryTime.text = "Delivery Time"
                        cell.txtDeliveryTime.delegate = self
                        cell.txtDeliveryTime.tag = indexPath.section
                    }else if DriverType.BusyDrivers.rawValue == indexPath.section{
                        objDriver = self.viewModel.getDriver().busyDrivers?[indexPath.row]
                    }else if DriverType.OfflineDrivers.rawValue == indexPath.section{
                        objDriver = self.viewModel.getDriver().offlineDrivers?[indexPath.row]
                        cell.vwDisable.isHidden = false
                        cell.isUserInteractionEnabled = false
                    }
                    
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
                }
               return cell
            }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.section {
                case DriverType.GoLocalFirstDrivers.rawValue:
                    if selectedIndex != nil && (self.selectedIndex.section  == indexPath.section && self.selectedIndex.row  == indexPath.row){
                        return 160
                    }else {
                        return 55
                    }
                    
                case DriverType.BusyDrivers.rawValue, DriverType.OfflineDrivers.rawValue:
                      return 75
                    
                    
                default:
                    if selectedIndex != nil && (self.selectedIndex.section  == indexPath.section && self.selectedIndex.row  == indexPath.row){
                        return 160
                    }else {
                        return 75
                    }
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if DriverType.BusyDrivers.rawValue == indexPath.section{
            let vc = DriverDetailsViewController(nibName: "DriverDetailsViewController", bundle: .main)
            vc.objDriver =  (self.viewModel.getDriver().busyDrivers?[indexPath.row])!
            driverStatusViewController?.navigationController?.pushViewController(vc, animated: true)
        }else {
            if DriverType.OfflineDrivers.rawValue != indexPath.section{
                if indexPath.section != DriverType.GoLocalFirstDrivers.rawValue{
                    driverStatusViewController?.selectedDriverId = self.viewModel.getDriver().availableDrivers?[indexPath.row].id ?? 0
                }else {
                    driverStatusViewController?.selectedDriverId = 0
                }
                selectedIndex = indexPath
                tableView.reloadData()
            }
        }
    }
    
}

    
    
    
