//
//  CommonAddTVCell.swift
//  GoLocalDriver
//
//  Created by C100-142 on 21/01/21.
//

import UIKit

class CommonAddTVCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var btnAddAccount: UIButton!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
