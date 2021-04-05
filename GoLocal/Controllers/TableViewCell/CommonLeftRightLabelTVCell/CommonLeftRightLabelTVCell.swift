//
//  CommonLeftRightLabelTVCell.swift
//  GoLocal
//
//  Created by C100-104 on 20/03/21.
//

import UIKit

class CommonLeftRightLabelTVCell: UITableViewCell {

    @IBOutlet weak var lblLeftValue: UILabel!
    @IBOutlet weak var lblRightValue: UILabel!{
        didSet{
            lblRightValue.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 13.0))
            lblRightValue.textColor = .systemGray2
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
