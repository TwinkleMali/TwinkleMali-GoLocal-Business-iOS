//
//  RatingTVCell.swift
//  GoLocalDriver
//
//  Created by C100-142 on 21/01/21.
//

import UIKit
import Cosmos

class RatingTVCell: UITableViewCell {

    
    @IBOutlet weak var lblRatingdescription: UILabel!
    @IBOutlet weak var lblRatingTime: UILabel!
    @IBOutlet weak var startratingView: CosmosView!
    @IBOutlet weak var btnReplayToReview: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
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
