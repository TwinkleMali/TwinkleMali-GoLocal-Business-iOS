//
//  TradeSelectionWithTextTVCell.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 13/04/21.
//

import UIKit

class TradeSelectionWithTextTVCell: UITableViewCell {

    @IBOutlet weak var lblOptionTitle: UILabel!
    @IBOutlet weak var imgSelectionType: UIImageView!
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
