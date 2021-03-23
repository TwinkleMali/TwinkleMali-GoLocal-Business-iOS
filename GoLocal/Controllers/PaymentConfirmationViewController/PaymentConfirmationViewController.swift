//
//  PaymentConfirmationViewController.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 18/03/21.
//

import UIKit
import Alamofire
class PaymentConfirmationViewController: BaseViewController {

    @IBOutlet weak var viewBackground: UIView!{
        didSet{
            viewBackground.alpha = 0.0
        }
    }
    @IBOutlet weak var lblMessageText: UILabel!{
        didSet{
            lblMessageText.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 24))
        }
    }
    @IBOutlet weak var btnCancelTransection: UIButton!{
        didSet{
            btnCancelTransection.titleLabel?.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 20))
        }
    }
    fileprivate var completionHandler: (AlertResult) -> () = {result  in }
    var isCancelOrderEnabled = true
    var paymentRequestId = 0
    var customerId = 0
    var cardPayAmount : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nc.addObserver(self, selector: #selector(handlePaymentRequestStatusChangeAck(notification:)), name: NSNotification.Name(rawValue: notificationCenterKeys.paymentRequestStatusChangeAck.rawValue), object: nil)
        nc.addObserver(self, selector: #selector(handleChangeBusinessPaymentRequestStatus(notification:)), name: NSNotification.Name(rawValue: notificationCenterKeys.changeBusinessPaymentRequestStatus.rawValue), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.viewBackground.alpha = 1.0
        }
    }
    @IBAction func actionCancel(_ sender: Any) {
        if isCancelOrderEnabled {
            let param : Parameters = ["payment_request_id":paymentRequestId,
                                      "customer_id":customerId,
                                      "shop_id":USER_DETAILS?.shopId ?? 0,
                                      "request_status":2,
                                      "card_pay_amount":cardPayAmount,
                                      "redeem_point":0,
                                      "payment_token":""]
            APP_DELEGATE?.socketIOHandler?.changeBusinessPaymentRequestStatus(dic: param)
            

        } else {
            showBanner(bannerTitle: .alert, message: "You can't cancel the request as customer has already accepted the payment request.", type: .warning)
        }
    }
    @objc func handlePaymentRequestStatusChangeAck(notification : Notification) {
        if let obj  = notification.userInfo  as? NSDictionary {
            print("@handlePaymentRequestStatusChangeAck : ",obj)
            if let status = obj["status"] as? Int ,status == 1{
                if let request_status = obj["paymnent_request_status"] as? String{
                    switch request_status {
                    case PAYMENT_REQUEST_STATUS.ACCEPT.rawValue:
                        isCancelOrderEnabled = false
                        break
                    case PAYMENT_REQUEST_STATUS.CANCELLED.rawValue:
                        self.completionHandler(.failure)
                        UIView.animate(withDuration: 0.1) {
                            self.viewBackground.alpha = 0.0
                        } completion: { (_) in
                            self.dismiss(animated: true, completion: nil)
                        }
                        break
                    case PAYMENT_REQUEST_STATUS.PAID.rawValue:
                        self.completionHandler(.success)
                        UIView.animate(withDuration: 0.1) {
                            self.viewBackground.alpha = 0.0
                        } completion: { (_) in
                            self.dismiss(animated: true, completion: nil)
                        }
                        break
                    default:
                        break
                    }
                }
            } else {
                print("failed to get status")
            }
        }
        
    }
    @objc func handleChangeBusinessPaymentRequestStatus(notification : Notification) {
        if let obj  = notification.userInfo  as? NSDictionary {
            print("@handleChangeBusinessPaymentRequestStatus : ",obj)
            if let status = obj["status"] as? Int ,status == 1,let message = obj["message"] as? String{
                self.showBanner(bannerTitle: .none, message: message, type: .info)
                self.completionHandler(.failure)
                UIView.animate(withDuration: 0.1) {
                    self.viewBackground.alpha = 0.0
                } completion: { (_) in
                    self.dismiss(animated: true, completion: nil)
                }
            }else {
                let message = obj["message"] as? String
                self.showBanner(bannerTitle: .failed, message: message ?? "Faild to cancel Order", type: .danger)
            }
        }
        
    }
    func setView( completion: @escaping (AlertResult) -> ()){
        completionHandler = completion
    }
}
