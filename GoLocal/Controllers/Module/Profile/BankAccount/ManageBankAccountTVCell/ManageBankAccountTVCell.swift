//
//  ManageBankAccountTVCell.swift
//  GoLocalDriver
//
//  Created by C100-142 on 21/01/21.
//

import UIKit

class ManageBankAccountTVCell: UITableViewCell {

    @IBOutlet weak var btnPrimary: UIButton!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
