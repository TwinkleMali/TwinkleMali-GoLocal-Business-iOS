//
//  DepositOptionTVCell.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 06/05/21.
//

import UIKit

class DepositOptionTVCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textAmount: UITextField!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var viewTextField: UIView!
    @IBOutlet weak var btnToggleView: UIButton!
    fileprivate var completionHandler: (Bool,String) -> () = { result,value in}
    var isViewOpen = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionToggleView(_ sender: Any) {
        isViewOpen = !isViewOpen
        self.viewTextField.isHidden = !isViewOpen
        self.imgArrow.image = isViewOpen ? #imageLiteral(resourceName: "top_arrow") : #imageLiteral(resourceName: "dropdown_arrow_icon")
        completionHandler(isViewOpen,textAmount.text ?? "")
    }
    func setview (completion : @escaping (Bool,String) -> ()){
        completionHandler = completion
    }
    @IBAction func actionTextChanged(_ sender: UITextField) {
        print("Text : ",sender.text)
        completionHandler(isViewOpen,sender.text ?? "")
        
    }
    func makeCurrencyPrefix() {
        self.textAmount.delegate = self
        let attributedString = NSMutableAttributedString(string: CURRENCY_SYMBOL)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:  UIColor.black
                                      , range: NSMakeRange(0,1))
        textAmount.attributedText = attributedString
    }
}
extension DepositOptionTVCell : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.typingAttributes = [NSAttributedString.Key.foregroundColor :  UIColor.black]
            let protectedRange = NSMakeRange(0, 1)
            let intersection = NSIntersectionRange(protectedRange, range)
            if intersection.length > 0 {
                return false
            }
            return true
    }
}
