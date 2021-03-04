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
        self.tableView.register("RequestDetailsOrderTVCell")
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
                if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestDetailsOrderTVCell", for: indexPath) as? RequestDetailsOrderTVCell {
                    cell.selectionStyle = .none
                    cell.lblOrderName.text = "Chobani@ Non-fat Greek Yogurt"
                    cell.lblOrderDescription.text = "Serving Size 1 cup, Servings per Container 4"
//                    cell.lblOrderIdValue.text = "Order ID: #GF42568FV"
                    cell.imgWidht.constant = 0
                    return cell
                }
                
            case DriverDetailsField.EstimatedReturnTime.rawValue:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTVCell", for: indexPath) as? OrderDetailsTVCell {
                    cell.lblTitle.text = "Estimated Return Time"
                    cell.lblValue.text = "12:47 PM"
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
        return UITableView.automaticDimension
    }
    
}
