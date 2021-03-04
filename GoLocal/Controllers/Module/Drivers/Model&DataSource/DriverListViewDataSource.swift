//
//  DriverListViewDataSource.swift
//  GoLocal
//
//  //  Created by C110 on 20/01/21.
//

import Foundation
import UIKit
class DriverListViewDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: DriverSeleListViewModel
    private let viewController: UIViewController
    private var driversListViewController : DriversListViewController? {
        get{
            viewController as? DriversListViewController
        }
    }
    private var selectedRow : Int = 0
    private var previousSelectedRow : Int = 0
    private var isFirstLaunch = true
    init(tableView: UITableView, viewModel: DriverSeleListViewModel, viewController: UIViewController) {
//        self.selectedRow = selectedIndex
//        self.previousSelectedRow = selectedIndex
        self.tableView = tableView
//        self.collectionView = collectionView
        self.viewModel = viewModel
        self.viewController = viewController
        self.tableView.register("SingleDriverTVCell")
//        self.tableView.register("SelectedProductDetailsTVCell")        
//        self.collectionView.register(UINib(nibName: "SingleCategoryNameCVCell", bundle: nil), forCellWithReuseIdentifier: "SingleCategoryNameCVCell")
    }
}
extension DriverListViewDataSource : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getDriverRowCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SingleDriverTVCell", for: indexPath) as? SingleDriverTVCell {
            cell.selectionStyle = .none
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
            
            if objDriver.driverStatus == DriverStatus.Offline.rawValue {
                cell.vwDriverStatus.backgroundColor = UIColor(named: "DarkGreyColor")
            }else if objDriver.driverStatus == DriverStatus.Available.rawValue {
                cell.vwDriverStatus.backgroundColor = UIColor(named: "GreenColor")
            }else {
                cell.vwDriverStatus.backgroundColor = UIColor.orange
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.getDriver(atPos: indexPath.row).driverStatus == DriverStatus.Busy.rawValue{
            let vc = DriverDetailsViewController(nibName: "DriverDetailsViewController", bundle: .main)
            vc.objDriver = self.viewModel.getDriver(atPos: indexPath.row)
            self.viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

