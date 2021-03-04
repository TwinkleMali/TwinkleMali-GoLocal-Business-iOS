//
//  RatingReplayTVCell.swift
//  GoLocalDriver
//
//  Created by C100-142 on 22/01/21.
//

import UIKit

class RatingReplayTVCell: UITableViewCell {

    @IBOutlet weak var lblReplayText: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var mainView: UIView!{
        didSet{
            mainView.layer.cornerRadius = 8
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
