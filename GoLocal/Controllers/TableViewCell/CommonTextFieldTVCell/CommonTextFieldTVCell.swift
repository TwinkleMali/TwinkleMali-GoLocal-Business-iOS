//
//  CommonTextFieldTVCell.swift
//  GoLocal
//
//  Created by C100-104on 17/12/20.
//

import UIKit

class CommonTextFieldTVCell: UITableViewCell {
    @IBOutlet weak var imgIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 15.0))
        }
    }
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var stviewRadio: UIStackView!
    @IBOutlet weak var rdb1: UIButton!
    @IBOutlet weak var rdb2: UIButton!
    @IBOutlet weak var rdb3: UIButton!
    @IBOutlet weak var textField: UITextField!{
        didSet{
            textField.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 16.0))
        }
    }
    @IBOutlet weak var btnHidePassword: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnRememberMe: UIButton!{
        didSet{
            btnRememberMe.titleLabel?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 13.0))
        }
    }
    @IBOutlet weak var btnForgotPassword: UIButton!{
        didSet{
            btnForgotPassword.titleLabel?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 13.0))
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func actionShowPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.textField.isSecureTextEntry = !sender.isSelected
        sender.imageView?.image =  sender.isSelected ? #imageLiteral(resourceName: "eye_view_g") : #imageLiteral(resourceName: "eye_view_b")
    }
    
    @IBAction func actionRememberMe(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.imageView?.image =  sender.isSelected ? #imageLiteral(resourceName: "icon_checkbox_checked") : #imageLiteral(resourceName: "icon_checkbox")
    }
}
