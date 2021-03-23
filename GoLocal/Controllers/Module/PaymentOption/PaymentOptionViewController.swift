//
//  PaymentOptionViewController.swift
//  GoLocal
//
//  Created by C110 on 18/1/21.
//

import UIKit
import Alamofire
class PaymentOptionViewController: BaseViewController{
  
    @IBOutlet weak var vwNav: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:- VARIABLES
    var dataSource: PaymentOptionDataSource?
    var scannedQRCode = ""
    var customerDetails : User? = nil
    var isOwnPaymentTerminal = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = PaymentOptionDataSource(tableView: tableView, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.tableFooterView = UIView()
        //socket API response hander
        nc.addObserver(self, selector: #selector(handleSendBusinessPaymentRequest(notification:)), name: NSNotification.Name(rawValue: notificationCenterKeys.sendBusinessPaymentRequest.rawValue), object: nil)
        nc.addObserver(self, selector: #selector(handleChangeBusinessPaymentRequestStatus(notification:)), name: NSNotification.Name(rawValue: notificationCenterKeys.changeBusinessPaymentRequestStatus.rawValue), object: nil)
        //Event handler
        nc.addObserver(self, selector: #selector(handlePaymentRequestStatusChangeAck(notification:)), name: NSNotification.Name(rawValue: notificationCenterKeys.paymentRequestStatusChangeAck.rawValue), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getCustomerDetails(code: scannedQRCode)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSendBusinessPaymentRequest(notification : Notification) {
        if let obj  = notification.userInfo  as? NSDictionary {
            print("@handleSendBusinessPaymentRequest : ",obj)
            if let message = obj["message"] as? String{
                self.showBanner(bannerTitle: .none, message: message, type: .success)
            }
            if let status = obj["status"] as? Int,
               status == 1,
               let data = obj["data"] as? NSDictionary,
               let payment_request_id = data["payment_request_id"] as? Int,
               let pay_amount = data["pay_amount"] as? Double {
                if self.isOwnPaymentTerminal{
                    self.back(withAnimation: true)
                } else {
                    let vc = PaymentConfirmationViewController.loadFromNib()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.paymentRequestId = payment_request_id
                    vc.customerId = customerDetails?.id ?? 0
                    vc.cardPayAmount = pay_amount
                    vc.setView { (result) in
                        switch result {
                            case .success :
                                self.back(withAnimation: true)
                                break
                        case .failure:
                            
                                break
                        }
                    }
                    present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func handleChangeBusinessPaymentRequestStatus(notification : Notification) {
        let obj  = notification.userInfo  as? [String : Any]
        print("@handleChangeBusinessPaymentRequestStatus : ",obj)
        
    }
    
    @objc func handlePaymentRequestStatusChangeAck(notification : Notification) {
        let obj  = notification.userInfo  as? [String : Any]
        print("@handlePaymentRequestStatusChangeAck : ",obj)
        
    }
    func sendPaymentRequest(isOwnPaymentTerminal : Bool,amount : Double){
        self.isOwnPaymentTerminal = isOwnPaymentTerminal
        let param : Parameters = [
            "customer_id": customerDetails?.id ?? 0,
            "shop_id" : USER_DETAILS?.shopId ?? 0,
            "pay_amount" : amount,
            "is_confirm": isOwnPaymentTerminal ? 1 : 0
        ]
        APP_DELEGATE?.socketIOHandler?.sendBusinessPaymentRequest(dic: param)
        
    }
}

