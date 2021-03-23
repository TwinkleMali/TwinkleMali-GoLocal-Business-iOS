//
//  ConfirmAmountAlert.swift
//  GoLocal
//
//  Created by C110 on 01/02/21.
//

import UIKit
import IQKeyboardManagerSwift
class ConfirmAmountAlert: BaseViewController {
    @IBOutlet weak var mainView: UIView!{
        didSet{
            mainView.layer.cornerRadius = 35
            mainView.clipsToBounds = true
            mainView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
   
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblCurrency: UILabel!{
        didSet{
            lblCurrency.text = CURRENCY_SYMBOL
        }
    }
    @IBOutlet weak var textAmount: UITextField!{
        didSet{
            textAmount.keyboardType = .decimalPad
            textAmount.font = UIFont(name: fFONT_BOLD, size: calculateFontForWidth(size: 34.0))
        }
    }
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTitle : UILabel!
    
    fileprivate var completionHandler: (Bool,Double) -> () = {(status,amount)  in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nc.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        textAmount.becomeFirstResponder()
    }
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    @IBAction func actionConfirm(_ sender: UIButton) {
        if let amount = Double(self.textAmount.text ?? "0"){
            completionHandler(true,amount)
            self.dismiss(animated: true, completion: nil)
        } else {
            self.showBanner(bannerTitle: .none, message: "Please Add valid amount to continue", type: .warning)
        }
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        completionHandler(false,0.0)
        self.dismiss(animated: true, completion: nil)
    }
    //MARk:- Keyboard Event
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.bottomConstraint.constant == 0 {
                self.bottomConstraint.constant = (keyboardSize.height)
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutSubviews()
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.bottomConstraint.constant != 0 {
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.2) {
                self.view.layoutSubviews()
            }
        }
    }
    
    func setView( completion: @escaping (Bool,Double) -> ()){
        completionHandler = completion
    }
}
