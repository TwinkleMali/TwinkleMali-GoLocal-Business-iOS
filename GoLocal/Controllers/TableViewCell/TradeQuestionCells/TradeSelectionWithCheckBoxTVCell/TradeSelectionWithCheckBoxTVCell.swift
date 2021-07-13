//
//  TradeSelectionWithCheckBoxTVCell.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 13/04/21.
//

import UIKit

class TradeSelectionWithCheckBoxTVCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewCheckBoxOption: UIView!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var lblOptionValue: UILabel!
    @IBOutlet weak var textFieldCustom: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
