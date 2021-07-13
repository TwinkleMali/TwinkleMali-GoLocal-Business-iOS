//
//  TradeExtraChargeRequestViewController.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 10/06/21.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
class TradeExtraChargeRequestViewController: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAmtTitle: UILabel!{
        didSet{
            lblAmtTitle.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 16))
        }
    }
    @IBOutlet weak var textField: UITextField!{
        didSet {
            textField.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 18))
            textField.keyboardType = .decimalPad
        }
    }
    @IBOutlet weak var lblDescriptionTitle: UILabel!{
        didSet{
            lblDescriptionTitle.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 16))
        }
    }
    @IBOutlet weak var textView: IQTextView!{
        didSet{
            textView.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 18))
        }
    }
    @IBOutlet weak var btnSendRequest: UIButton!
    
    var requestId = 0
    var responseId = 0
    var customerId = 0
    var amount :Double = 0
    fileprivate var completionHandler: (AlertResult) -> () = {result  in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCurrencyPrefix()
        nc.addObserver(self, selector: #selector(ExtraChargeRequestResponse(notification:)), name: Notification.Name(notificationCenterKeys.makeExtraChargeRequest.rawValue), object: nil)
    }
    @IBAction func actionBack(_ sender: Any) {
        self.back(withAnimation: true)
    }
    @IBAction func actionSendRequest(_ sender: Any) {
        if amount > 0 {
            sendRequest()
        } else {
            self.showBanner(bannerTitle: .validation, message: "Please enter extra charge amount", type: .warning)
        }
    }
    @IBAction func actionTextChanged(_ sender: UITextField) {
        if sender.text?.count ?? 0 == 1 && sender.text ?? "" != CURRENCY_SYMBOL{
           let val = sender.text ?? ""
            sender.text = "\(CURRENCY_SYMBOL)\(val)"
        }
        print("Text : ",sender.text)
        amount = Double((sender.text ?? "0").replacingOccurrences(of: CURRENCY_SYMBOL, with: "")) ?? 0
    }
    //MARK:- Functions
    func setView( completion: @escaping (AlertResult) -> ()){
        completionHandler = completion
    }
    
    func makeCurrencyPrefix() {
        self.textField.delegate = self
        let attributedString = NSMutableAttributedString(string: CURRENCY_SYMBOL)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:  UIColor.black
                                      , range: NSMakeRange(0,1))
        textField.attributedText = attributedString
        textField.text = ""
    }
    @objc func ExtraChargeRequestResponse(notification:Notification){
        
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let status = dict["status"] as? Int ,let message = dict["message"] as? String{
                self.showBanner(bannerTitle: .none, message: message, type: .warning)
                if status == 1 {
                    self.back(withAnimation: true)
                    completionHandler(.success)
                }
            }
        }
    }
    
    func sendRequest(){
        let param : Parameters = [
            "customer_id": customerId,
            "request_id": requestId,
            "response_id":responseId,
            "charge":amount,
            "charge_description":textView.text ?? ""
        ]
        print("param :",param )
        APP_DELEGATE?.socketIOHandler?.makeExtraChargeRequest(dic: param)
    }
}


extension TradeExtraChargeRequestViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.typingAttributes = [NSAttributedString.Key.foregroundColor :  UIColor.black]
            let protectedRange = NSMakeRange(0, 1)
            let intersection = NSIntersectionRange(protectedRange, range)
        if textField.text?.count ?? 0 > 1 && intersection.length > 0 {
                return false
            }
            return true
    }
}
