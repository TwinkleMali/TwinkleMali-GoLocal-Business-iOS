//
//  PaymentOptionTVCell.swift
//  GoLocal
//
//  //  Created by C110 on 20/1/21.
//

import UIKit

class PaymentOptionTVCell: UITableViewCell {

   
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var btnIcon : UIButton!
    @IBOutlet weak var btnArrow : UIButton!
    @IBOutlet weak var vwMain : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
