//
//  AddAccountTextFieldTVCell.swift
//  GoLocalDriver
//
//  Created by C100-142 on 21/01/21.
//

import UIKit

class AddAccountTextFieldTVCell: UITableViewCell {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var btnSelection: UIButton!
    @IBOutlet weak var accountTypeView: UIView!
    @IBOutlet weak var btnSaving: UIButton!
    @IBOutlet weak var imgRadioOption: UIImageView!
    @IBOutlet weak var btnCurrent: UIButton!
    @IBOutlet weak var imgRadioOption1: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnSelection(_ sender: UIButton) {
//        if sender == btnSaving {
//            imgRadioOption.image = #imageLiteral(resourceName: "icon_option_select")
//            imgRadioOption1.image = #imageLiteral(resourceName: "icon_radio_black_unselect")
//
//        }else{
//            imgRadioOption.image = #imageLiteral(resourceName: "icon_radio_black_unselect")
//            imgRadioOption1.image = #imageLiteral(resourceName: "icon_option_select")
//        }
    }
    @IBAction func btnAccountTypeAction(_ sender: UIButton) {
    }
}
