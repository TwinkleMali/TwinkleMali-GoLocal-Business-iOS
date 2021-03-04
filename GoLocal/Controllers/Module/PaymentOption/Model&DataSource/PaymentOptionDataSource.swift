//
//  PaymentOptionDataSource.swift
//  GoLocal
//
//  //  Created by C110 on 20/01/21.
//

import Foundation
import UIKit
class PaymentOptionDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewController: UIViewController
    private var paymentOptionViewController : PaymentOptionViewController? {
        get{
            viewController as? PaymentOptionViewController
        }
    }
    private var selectedRow : Int = 0
    private var previousSelectedRow : Int = 0
    init(tableView: UITableView, viewController: UIViewController) {
        self.tableView = tableView
        self.viewController = viewController
        self.tableView.register("PaymentOptionTVCell")
    }
}
extension PaymentOptionDataSource : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PaymentOption.Total.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionTVCell", for: indexPath) as? PaymentOptionTVCell {
            cell.selectionStyle = .none
            cell.btnArrow.tag = indexPath.row
//            cell.btnArrow.addTarget(self.paymentOptionViewController, action: #selector(self.paymentOptionViewController?.moveToScanView(_:)), for: .touchUpInside)
            switch indexPath.row {
            
            case PaymentOption.OwnTerminal.rawValue:
                cell.lblTitle.text = "Pay using own payment terminal"
                cell.btnIcon.setImage(UIImage(named: "payment_own_terminal_icon"), for: .normal)
                return cell
                
            case PaymentOption.GoLocalFirst.rawValue:
                cell.lblTitle.text = "Pay using Go Local First"
                cell.btnIcon.setImage(UIImage(named: "payment_golocal_first_icon"), for: .normal)
                return cell
                
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ConfirmAmountAlert(nibName: "ConfirmAmountAlert", bundle: nil)
        self.paymentOptionViewController?.present(vc, animated: true, completion: nil)
    }
}
