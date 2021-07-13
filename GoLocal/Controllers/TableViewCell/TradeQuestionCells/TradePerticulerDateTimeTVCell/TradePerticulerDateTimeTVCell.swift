//
//  TradePerticulerDateTimeTVCell.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 13/04/21.
//

import UIKit

class TradePerticulerDateTimeTVCell: UITableViewCell {

    @IBOutlet weak var btnCalender: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
