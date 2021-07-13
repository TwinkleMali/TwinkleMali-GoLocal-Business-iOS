//
//  TradeCustomDateTimeTVCell.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 13/04/21.
//

import UIKit
import IQKeyboardManagerSwift
class TradeCustomDateTimeTVCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var viewTextView: CardView!
    @IBOutlet weak var viewTextField: UIStackView!
    @IBOutlet weak var textView: IQTextView!
    
    fileprivate var completionHandler : (String) -> () = {text in}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func actionTextChanged(_ sender: UITextField) {
        if sender.text?.count ?? 0 == 1 && sender.text ?? "" != CURRENCY_SYMBOL{
           let val = sender.text ?? ""
            sender.text = "\(CURRENCY_SYMBOL)\(val)"
        }
        print("Text : ",sender.text)
        
        completionHandler(sender.text ?? "")
        
    }
    func setview(completion : @escaping (String) -> ()){
        self.completionHandler = completion
    }
    func makeCurrencyPrefix() {
        self.textField.delegate = self
        let attributedString = NSMutableAttributedString(string: CURRENCY_SYMBOL)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:  UIColor.black
                                      , range: NSMakeRange(0,1))
        textField.attributedText = attributedString
    }
}
extension TradeCustomDateTimeTVCell : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.typingAttributes = [NSAttributedString.Key.foregroundColor :  UIColor.black]
            let protectedRange = NSMakeRange(0, 1)
            let intersection = NSIntersectionRange(protectedRange, range)
        if textField.text?.count ?? 0 > 1 && intersection.length > 0 {
                return false
            }
//            if range.location == 12 {
//                return true
//            }
//            if range.location + range.length > 12 {
//                return false
//            }
            return true
    }
}
