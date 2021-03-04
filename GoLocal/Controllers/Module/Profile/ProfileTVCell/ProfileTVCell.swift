//
//  ProfileTVCell.swift
//  GoLocalDriver
//
//  Created by C100-142 on 20/01/21.
//

import UIKit

class ProfileTVCell: UITableViewCell {

    @IBOutlet weak var lblItemTitle: UILabel!
    @IBOutlet weak var imgItemImage: UIImageView!
    @IBOutlet weak var btnNavigateToScreens: UIButton!
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
