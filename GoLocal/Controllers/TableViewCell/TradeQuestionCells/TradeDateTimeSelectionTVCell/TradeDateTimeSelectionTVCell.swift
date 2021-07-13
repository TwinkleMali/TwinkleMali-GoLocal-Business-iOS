//
//  TradeDateTimeSelectionTVCell.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 13/04/21.
//

import UIKit

class TradeDateTimeSelectionTVCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnSelectDate: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnTime: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
