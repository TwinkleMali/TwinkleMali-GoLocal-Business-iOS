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
        if let _ = paymentOptionViewController?.customerDetails {
            return (PaymentOption.Total.rawValue + 1)
        }
        return PaymentOption.Total.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == PaymentOption.Total.rawValue, let customerDetails = paymentOptionViewController?.customerDetails{
            let cell = UITableViewCell(style: .default, reuseIdentifier: "CustomerName")
            let value1 = "Payment from "
            let value2 = "\(customerDetails.name ?? "") \(customerDetails.lname ?? "")"
            
            let size1 = calculateFontForWidth(size: 15)
            let size2 = calculateFontForWidth(size: 16)
            let finalText = value1 + value2
            let firstAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: fFONT_MEDIUM, size: size1)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray]
            let secondAttributes : [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: fFONT_BOLD, size: size2)!, NSAttributedString.Key.foregroundColor : UIColor.black]
            
            let firstString = NSMutableAttributedString(string: value1, attributes: firstAttributes)
            let secondString = NSMutableAttributedString(string: value2, attributes: secondAttributes)
            firstString.append(secondString)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing =  3
            firstString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, finalText.length))
            cell.textLabel?.attributedText = firstString
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionTVCell", for: indexPath) as? PaymentOptionTVCell {
            cell.selectionStyle = .none
            cell.btnArrow.tag = indexPath.row
//            cell.btnArrow.addTarget(self.paymentOptionViewController, action: #selector(self.paymentOptionViewController?.moveToScanView(_:)), for: .touchUpInside)
            switch indexPath.row {
            
            case PaymentOption.OwnTerminal.rawValue:
                cell.lblTitle.text = "Pay using own payment terminal"
                cell.btnIcon.setImage(UIImage(named: "payment_own_terminal_icon"), for: .normal)
                return cell
                
            case PaymentOption.GoLocalFirst.rawValue:
                cell.lblTitle.text = "Confirm amount for customer to pay"
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
        if indexPath.row < PaymentOption.Total.rawValue {
            let paymentType = indexPath.row
            
            let vc = ConfirmAmountAlert(nibName: "ConfirmAmountAlert", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            vc.setView { (isSubmitted, amount) in
                if isSubmitted {
                    self.paymentOptionViewController?.sendPaymentRequest(isOwnPaymentTerminal: indexPath.row == 0, amount: amount)
                }
            }
            self.paymentOptionViewController?.present(vc, animated: true, completion: nil)
        }
    }
}
