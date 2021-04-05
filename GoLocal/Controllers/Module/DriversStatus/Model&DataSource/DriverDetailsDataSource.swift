//
//  DriverDetailsDataSource.swift
//  GoLocal
//
//  //  Created by C110 on 20/01/21.
//

import Foundation
import UIKit
class DriverDetailsDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: DriverSeleListViewModel
    private let viewController: UIViewController
    private var driverDetailsViewController : DriverDetailsViewController? {
        get{
            viewController as? DriverDetailsViewController
        }
    }
    
    init(tableView: UITableView, viewModel: DriverSeleListViewModel, viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        self.tableView.register("DriverStatusMap")
        self.tableView.register("OrderDetailsTVCell")
        self.tableView.register("SingleDriverTVCell")
    }
}

extension DriverDetailsDataSource : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DriverDetailsField.Total.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch indexPath.row {
                case DriverDetailsField.Map.rawValue:
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "DriverStatusMap", for: indexPath) as? SelectDriverTVCell {

                        cell.selectionStyle = .none
                        return cell
                    }
                    
            case DriverDetailsField.Details.rawValue:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SingleDriverTVCell", for: indexPath) as? SingleDriverTVCell {
                    cell.selectionStyle = .none
                    cell.viewWidth.constant = 0
                    cell.lblDriverName.text = viewModel.getDriverOrder().shopDetail?.name.asStringOrEmpty()
                    cell.lblDriverNumber.text = viewModel.getDriverOrder().shopDetail?.shopDesc.asStringOrEmpty()
                    cell.lblOwnerTime.text = "Order ID :  \(viewModel.getDriverOrder().orderUniqueId.asStringOrEmpty())"
                    cell.lblOwnerTime.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 15.0))
                     
                    cell.lblDriverTime.isHidden = true
                    cell.vwDriverStatus.isHidden = true
                    
                    return cell
                }
                
            case DriverDetailsField.EstimatedReturnTime.rawValue:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTVCell", for: indexPath) as? OrderDetailsTVCell {
                    cell.lblTitle.text = "Estimated Return Time"
                    cell.lblValue.text = "\(viewModel.getDriverOrder().estimatedDeliveryTime.asStringOrEmpty()) Minute"
                    cell.selectionStyle = .none
                    return cell
                }
                
            case DriverDetailsField.PostalCode.rawValue:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTVCell", for: indexPath) as? OrderDetailsTVCell {
                    cell.lblTitle.text = "Delivery Postcode"
                    cell.lblValue.text = "395005"
                    cell.selectionStyle = .none
                    return cell
                }
                    
                default:
//                    cell.lblDriverName.text = "Killoer"
                    return UITableViewCell()
            }
            return UITableViewCell()
        }
        
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == DriverDetailsField.PostalCode.rawValue{
            return 0
        }
        return UITableView.automaticDimension
    }
    
}
