//
//  TradeRecuringOptionsTVCell.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 13/04/21.
//

import UIKit

class TradeRecuringOptionsTVCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSelectedValue: UILabel!
    @IBOutlet weak var btnShowOption: UIButton!
    @IBOutlet weak var viewOptions: CardView!
    @IBOutlet weak var btnWeekly: UIButton!
    @IBOutlet weak var btnFortnightly: UIButton!
    @IBOutlet weak var btnMonthly: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var heightOptionView: NSLayoutConstraint! // 0 / 200
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
