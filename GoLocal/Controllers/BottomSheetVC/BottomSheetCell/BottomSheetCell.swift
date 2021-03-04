//
//  BottomSheetCell.swift
//  GoLocal
//
//  Created by C110 on 17/12/20.
//

import UIKit

class BottomSheetCell: UITableViewCell {

    @IBOutlet weak var btnselect: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
