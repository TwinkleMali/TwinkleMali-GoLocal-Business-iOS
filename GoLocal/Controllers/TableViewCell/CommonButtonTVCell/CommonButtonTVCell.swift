//
//  CommonButtonTVCell.swift
//  GoLocal
//
//  Created by C100-104on 17/12/20.
//

import UIKit

class CommonButtonTVCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnSubmit: UIButton!{
        didSet{
            btnSubmit.titleLabel?.font = UIFont(name: fFONT_MEDIUM, size: 17.0)
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
