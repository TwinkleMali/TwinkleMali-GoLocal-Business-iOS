//
//  MobileNumberTVCell.swift
//  GoLocal
//
//  Created by C100-104on 18/12/20.
//

import UIKit

class MobileNumberTVCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 15.0))
        }
    }
    @IBOutlet weak var lblCountryPhoneCode: UILabel!{
        didSet{
            lblCountryPhoneCode.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 16.0))
        }
    }
    @IBOutlet weak var textPhoneNumber: UITextField!{
        didSet{
            textPhoneNumber.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 16.0))
        }
    }
    @IBOutlet weak var imgDownArrow: UIImageView!{
        didSet{
            let templateImage = imgDownArrow.image?.withRenderingMode(.alwaysTemplate)
            imgDownArrow.image = templateImage
            imgDownArrow.tintColor = .black
        }
    }
    @IBOutlet weak var btnCodePicker: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
